# frozen_string_literal: true

module Dependabot
  module Dependencies
    # Updated dependency container
    #
    class UpdatedDependency
      # :reek:LongParameterList

      # @param [String] name
      # @param [Integer] state
      # @param [Array<Dependabot::Dependency>] updated_dependencies
      # @param [Array<Dependabot::DependencyFile>] updated_files
      # @param [Boolean] vulnerable
      # @param [Hash] auto_merge_rules
      # @param [Array<Vulnerability>] fixed_vulnerabilities
      # rubocop:disable Metrics/ParameterLists
      def initialize(
        name:,
        state:,
        updated_dependencies: nil,
        updated_files: nil,
        vulnerable: nil,
        auto_merge_rules: nil,
        fixed_vulnerabilities: []
      )
        @name = name
        @state = state
        @updated_dependencies = updated_dependencies
        @updated_files = updated_files
        @vulnerable = vulnerable
        @fixed_vulnerabilities = fixed_vulnerabilities
        @auto_merge_rules = auto_merge_rules
      end
      # rubocop:enable Metrics/ParameterLists

      # @return [String] main dependency name
      attr_reader :name
      # @return [Integer] update state
      attr_reader :state
      # @return [Array<Dependabot::Dependency>] updated dependencies
      attr_reader :updated_dependencies
      # @return [Array<Dependabot::DependencyFile>] updated files
      attr_reader :updated_files
      # @return [Boolean]
      attr_reader :vulnerable
      # @return [Array<Vulnerability>] fixed vulnerabilities
      attr_reader :fixed_vulnerabilities
      # @return [Hash] merge rules
      attr_reader :auto_merge_rules

      # All dependencies to be updated with new versions
      #
      # @return [String]
      def current_versions
        @current_versions ||= updated_dependencies.map { |dep| "#{dep.name}-#{dep.version}" }.join("/")
      end

      # All dependencies being updated with previous versions
      #
      # @return [String]
      def previous_versions
        @previous_versions ||= updated_dependencies.map { |dep| "#{dep.name}-#{dep.previous_version}" }.join("/")
      end

      # Allow automerging dependency update
      #
      # @return [Boolean]
      def auto_mergeable?
        @auto_mergeable ||= auto_merge_rules && (allow_automerge && !ignore_automerge)
      end

      # Object comparator
      # @param [UpdatedDependency] other
      # @return [Booelan]
      def ==(other)
        self.class == other.class && comparable == other.comparable
      end

      # Updates present
      #
      # @return [Boolean]
      def updates?
        state == UpdateChecker::HAS_UPDATES
      end

      # Update is not possible
      #
      # @return [Boolean]
      def update_impossible?
        state == UpdateChecker::UPDATE_IMPOSSIBLE
      end

      # Dependency is up to date
      #
      # @return [Boolean]
      def up_to_date?
        state == UpdateChecker::UP_TO_DATE
      end

      # Update was skipped
      #
      # @return [Boolean]
      def skipped?
        state == UpdateChecker::SKIPPED
      end

      protected

      # Object state
      # @return [Array]
      def comparable
        instance_variables.map { |var| instance_variable_get(var) }
      end

      private

      # Allow automerge
      #
      # @return [Boolean]
      def allow_automerge
        return true unless auto_merge_rules[:allow]

        satisfies_rule?(auto_merge_rules[:allow])
      end

      # Ignore automerge
      #
      # @return [Boolean]
      def ignore_automerge
        return false unless auto_merge_rules[:ignore]

        satisfies_rule?(auto_merge_rules[:ignore])
      end

      # Rule satisfies version update
      #
      # @param [Array<Hash>] rules
      # @return [Boolean]
      def satisfies_rule?(rules)
        updated_dependencies.any? do |dependency|
          RuleHandler.version_conditions(dependency, rules)&.any? do |rule|
            SemanticRange.satisfies?(dependency.version, rule.gsub(",", " ||").tr("a", "x"))
          end
        end
      end
    end
  end
end
