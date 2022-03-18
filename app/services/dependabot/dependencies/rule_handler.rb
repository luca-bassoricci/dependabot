# frozen_string_literal: true

require "dependabot/config/update_config"

module Dependabot
  module Dependencies
    # Allow/ignore rule handling
    #
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

      def initialize(dependency:, checker:, config_entry:)
        @dependency = dependency
        @checker = checker
        @allow = config_entry[:allow]
        @ignore = config_entry[:ignore]
        @versioning_strategy = config_entry[:versioning_strategy]
      end

      # Version conditions for dependency
      #
      # @param [Dependabot::Dependency] dependency
      # @param [Array, nil] conditions
      # @return [Array]
      def self.version_conditions(dependency, conditions)
        return unless conditions

        # Dependabot uses it for ignore only, but ranges can actually be used for both allow and ignore conditions
        ignore_conditions = conditions.map { |ic| Dependabot::Config::IgnoreCondition.new(**ic) }
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
        Dependabot::Config::UpdateConfig.wildcard_match?(rule[:dependency_name], dependency.name)
      end

      # Dependency specific allow rules
      #
      # @return [Array<Hash>]
      def dependency_rules
        @dependency_rules ||= allow.select { |entry| entry[:dependency_name] }
      end
    end
  end
end
