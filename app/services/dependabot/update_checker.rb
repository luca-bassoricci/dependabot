# frozen_string_literal: true

module Dependabot
  class UpdateChecker < ApplicationService
    # @param [Dependabot::Dependency] dependency
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @param [Array<Hash>] ignore
    def initialize(dependency:, dependency_files:, ignore:)
      @dependency = dependency
      @dependency_files = dependency_files
      # Ignore entries with only name defined already removed at an earlier stage
      @ignore = ignore.select { |entry| entry[:versions] }
    end

    # Get update checker
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      logger.info { "Checking if #{name} needs updating" }
      return up_to_date if checker.up_to_date?

      logger.info { "Latest version for #{dependency.name} is #{checker.latest_version}" }
      return ignored if matches_ignore?
      return update_impossible if requirements_to_unlock == :update_not_possible

      updated_dependencies
    end

    private

    attr_reader :dependency, :dependency_files, :ignore

    # Full dependency name
    #
    # @return [String]
    def name
      @name ||= "#{dependency.name} #{dependency.version}"
    end

    # Print up to date message
    #
    # @return [Array]
    def up_to_date
      logger.info { "No update needed for #{name}" }
      []
    end

    # Print skip due to ignore rules message
    #
    # @return [Array]
    def ignored
      logger.info { "Skipping #{dependency.name} update to #{checker.latest_version} due to ignore rules" }
      []
    end

    # Print update impossible message
    #
    # @return [Array]
    def update_impossible
      logger.info { "Update impossible for #{name}" }
      []
    end

    # Get filtered updated dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def updated_dependencies
      @updated_dependencies ||= checker.updated_dependencies(requirements_to_unlock: requirements_to_unlock)
    end

    # Get update checker
    #
    # @return [Dependabot::UpdateChecker]
    def checker
      @checker ||= Dependabot::UpdateCheckers.for_package_manager(dependency.package_manager).new(
        dependency: dependency,
        dependency_files: dependency_files,
        credentials: Credentials.fetch
      )
    end

    # Get requirements to unlock
    #
    # @return [Symbol]
    def requirements_to_unlock
      @requirements_to_unlock ||= begin
        unless checker.requirements_unlocked_or_can_be?
          return checker.can_update?(requirements_to_unlock: :none) ? :none : :update_not_possible
        end
        return :own if checker.can_update?(requirements_to_unlock: :own)
        return :all if checker.can_update?(requirements_to_unlock: :all)

        :update_not_possible
      end
    end

    # Check if dependency matches ignore pattern
    #
    # @return [Boolean]
    def matches_ignore?
      ignore.any? do |entry|
        dependency.name.match?(entry[:dependency_name]) && entry[:versions].any? do |ver|
          SemanticRange.satisfies(checker.latest_version.to_s, ver)
        end
      end
    end
  end
end
