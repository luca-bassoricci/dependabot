# frozen_string_literal: true

require "dependabot/config/update_config"

module Dependabot
  class RuleHandler
    # @return [Hash<String, Proc>] handlers for type allow rules
    TYPE_HANDLERS = {
      "all" => proc { true },
      "direct" => proc { |dep| dep.top_level? },
      "indirect" => proc { |dep| !dep.top_level? },
      "production" => proc { |dep| dep.production? },
      "development" => proc { |dep| !dep.production? },
      "security" => proc { |_, checker| checker.vulnerable? }
    }.freeze

    def initialize(dependency:, checker:, config:)
      @dependency = dependency
      @checker = checker
      @allow = config[:allow]
      @ignore = config[:ignore]
      @versioning_strategy = config[:versioning_strategy]
    end

    # Ignored versions for dependency
    #
    # @param [Dependabot::Dependency] dependency
    # @param [Array] ignore
    # @return [Array]
    def self.ignored_versions(dependency, ignore)
      ignore_conditions = ignore.map { |ic| Dependabot::Config::IgnoreCondition.new(**ic) }

      Dependabot::Config::UpdateConfig.new(ignore_conditions: ignore_conditions).ignored_versions_for(dependency)
    end

    # Check if dependency matches allowed rules
    #
    # @return [Boolean]
    def allowed?
      return checker.vulnerable? || global_rules.all? { |rule| matches_type?(rule) } if dependency_rules.empty?

      dependency_rules.any? { |rule| matches_name?(rule) && matches_type?(rule) }
    end

    private

    # @return [Dependabot::Dependency]
    attr_reader :dependency
    # @return [Dependabot::UpdateChecker]
    attr_reader :checker
    # @return [Array<Hash>]
    attr_reader :allow
    # @return [Array<Hash>]
    attr_reader :ignore
    # @return [Symbol]
    attr_reader :versioning_strategy

    # Global allow rules
    #
    # @return [Array<Hash>]
    def global_rules
      @global_rules ||= allow.select { |entry| !entry[:dependency_name] && entry[:dependency_type] }
    end

    # Matches defined dependency type
    #
    # @param [Hash<Symbol, String>] rule
    # @return [Boolean]
    def matches_type?(rule)
      TYPE_HANDLERS[rule.fetch(:dependency_type, "direct")].call(dependency, checker)
    end

    # Matches defined dependency name
    #
    # @param [Hash<Symbol, String>] rule
    # @return [Boolean]
    def matches_name?(rule)
      dependency.name.match?((rule[:dependency_name]))
    end

    # Dependency specific allow rules
    #
    # @return [Array<Hash>]
    def dependency_rules
      @dependency_rules ||= allow.select { |entry| entry[:dependency_name] }
    end
  end
end
