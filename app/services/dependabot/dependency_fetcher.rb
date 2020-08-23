# frozen_string_literal: true

module Dependabot
  class DependencyFetcher < ApplicationService
    # @return [Hash<String, Proc>] handlers for type allow rules
    TYPE_HANDLERS = {
      "all" => ->(_) { true },
      "direct" => ->(dep) { dep.top_level? },
      "indirect" => ->(dep) { !dep.top_level? },
      "production" => ->(dep) { dep.production? },
      "development" => ->(dep) { !dep.production? }
    }.freeze

    # @param [Dependabot::Source] :source
    # @param [Array<Dependabot::DependencyFile>] :dependency_files
    # @param [String] :package_manager
    # @param [Hash] opts
    # @option opts [Array<Hash>] :allow
    # @option params [Array<Hash>] :ignore
    # @option params [Number] :open_merge_requests
    def initialize(source:, dependency_files:, package_manager:, **opts)
      @source = source
      @dependency_files = dependency_files
      @package_manager = package_manager
      @allow = opts[:allow]
      @ignore = opts[:ignore]
      @open_merge_requests = opts[:open_merge_requests]
    end

    # Get dependency list
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      return allowed_dependencies if ignore.empty?

      # Remove dependencies early that doesn't require checking for new version to save time
      allowed_dependencies.reject do |dep|
        ignore.any? { |entry| !entry[:versions] && matches_name?(dep, entry) }
      end
    end

    private

    attr_reader :source,
                :dependency_files,
                :package_manager,
                :allow,
                :ignore,
                :open_merge_requests

    # Dependencies filtered according to allow rules
    #
    # @return [Array<Dependabot::Dependency>]
    def allowed_dependencies
      @allowed_dependencies ||= all_dependencies.select(&allow_filter)
    end

    # All dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def all_dependencies
      @all_dependencies ||= FileParser.call(
        dependency_files: dependency_files,
        source: source,
        package_manager: package_manager
      )
    end

    # Allowed dependency select filter
    #
    # @return [Proc]
    def allow_filter
      return ->(dep) { global_rules.all? { |entry| matches_type?(dep, entry) } } if dependency_rules.empty?

      ->(dep) { dependency_rules.any? { |entry| matches_name?(dep, entry) && matches_type?(dep, entry) } }
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

    # Matches defined dependency name
    #
    # @param [Dependabot::Dependency] dep
    # @param [Hash<Symbol, String>] entry
    # @return [Boolean]
    def matches_name?(dep, entry)
      dep.name.match?("^#{entry[:dependency_name]}$")
    end

    # Matches defined dependency type
    #
    # @param [Dependabot::Dependency] dep
    # @param [Hash<Symbol, String>] entry
    # @return [Boolean]
    def matches_type?(dep, entry)
      type = entry.fetch(:dependency_type, "direct")

      TYPE_HANDLERS.fetch(type, "direct").call(dep)
    end
  end
end
