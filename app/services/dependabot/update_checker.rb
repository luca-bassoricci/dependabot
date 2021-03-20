# frozen_string_literal: true

module Dependabot
  class UpdateChecker < ApplicationService
    # @return [Hash<String, Proc>] handlers for type allow rules
    TYPE_HANDLERS = {
      "all" => proc { true },
      "direct" => proc { |dep| dep.top_level? },
      "indirect" => proc { |dep| !dep.top_level? },
      "production" => proc { |dep| dep.production? },
      "development" => proc { |dep| !dep.production? },
      "security" => proc { |_, checker| checker.vulnerable? }
    }.freeze

    # @param [Dependabot::Dependency] dependency
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @param [Array<Hash>] allow
    # @param [Array<Hash>] ignore
    # @param [String] versioning_strategy
    def initialize(dependency:, dependency_files:, allow:, ignore:, versioning_strategy: nil)
      @dependency = dependency
      @dependency_files = dependency_files
      @allow = allow
      @ignore = ignore
      @versioning_strategy = versioning_strategy
    end

    # Get updated dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      return skipped if !allowed? || ignored?

      log(:info, "Fetching info for #{name}")
      return up_to_date if checker.up_to_date?
      return update_impossible if requirements_to_unlock == :update_not_possible

      updated_dependencies
    rescue StandardError => e
      log_error(e)
      nil
    end

    private

    attr_reader :dependency, :dependency_files, :allow, :ignore, :versioning_strategy

    # Full dependency name
    #
    # @return [String]
    def name
      @name ||= "#{dependency.name} #{dependency.version}"
    end

    # Print skipped message
    #
    # @return [nil]
    def skipped
      log(:debug, "Skipping #{name} due to allow/ignore rules")
      nil
    end

    # Print up to date message
    #
    # @return [nil]
    def up_to_date
      log(:info, "#{name} is up to date")
      nil
    end

    # Print update impossible message
    #
    # @return [nil]
    def update_impossible
      log(:info, "Update for #{name} is impossible")
      nil
    end

    # Get filtered updated dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def updated_dependencies
      log(:info, "found version for update: #{name} => #{checker.latest_version}")

      {
        updated_dependencies: checker.updated_dependencies(requirements_to_unlock: requirements_to_unlock),
        vulnerable: checker.vulnerable?,
        security_advisories: checker.security_advisories
      }
    end

    # Get update checker
    #
    # @return [Dependabot::UpdateChecker]
    def checker
      @checker ||= begin
        args = {
          dependency: dependency,
          dependency_files: dependency_files,
          credentials: Credentials.fetch
        }
        args[:requirements_update_strategy] = versioning_strategy if versioning_strategy && !lockfile_only?
        Dependabot::UpdateCheckers.for_package_manager(dependency.package_manager).new(**args)
      end
    end

    # Get requirements to unlock
    #
    # @return [Symbol]
    def requirements_to_unlock
      @requirements_to_unlock ||= begin
        if lockfile_only? || !checker.requirements_unlocked_or_can_be?
          return checker.can_update?(requirements_to_unlock: :none) ? :none : :update_not_possible
        end
        return :own if checker.can_update?(requirements_to_unlock: :own)
        return :all if checker.can_update?(requirements_to_unlock: :all)

        :update_not_possible
      end
    end

    # Global allow rules
    #
    # @return [Array<Hash>]
    def global_rules
      @global_rules ||= allow.select { |entry| !entry[:dependency_name] && entry[:dependency_type] }
    end

    # Dependency specific allow rules
    #
    # @return [Array<Hash>]
    def dependency_rules
      @dependency_rules ||= allow.select { |entry| entry[:dependency_name] }
    end

    # Check if dependency matches allowed rules
    #
    # @return [Boolean]
    def allowed?
      return checker.vulnerable? || global_rules.all? { |rule| matches_type?(rule) } if dependency_rules.empty?

      dependency_rules.any? { |rule| matches_name?(rule) && matches_type?(rule) }
    end

    # Check if dependency matches ignore rules
    #
    # @return [Boolean]
    def ignored?
      ignore.any? { |rule| matches_name?(rule) && matches_versions?(rule[:versions]) }
    end

    # Matches defined dependency name
    #
    # @param [Hash<Symbol, String>] rule
    # @return [Boolean]
    def matches_name?(rule)
      dependency.name.match?((rule[:dependency_name]))
    end

    # Matches defined dependency type
    #
    # @param [Hash<Symbol, String>] rule
    # @return [Boolean]
    def matches_type?(rule)
      TYPE_HANDLERS[rule.fetch(:dependency_type, "direct")].call(dependency, checker)
    end

    # Matches defined dependency version or range
    #
    # @param [Array] versions
    # @return [Boolean]
    def matches_versions?(versions)
      return true unless versions

      versions.any? do |version|
        SemanticRange.satisfies(checker.latest_version.to_s, version)
      end
    end

    # Versioning strategy set to lock file only
    #
    # @return [Boolean]
    def lockfile_only?
      versioning_strategy == :lockfile_only
    end
  end
end
