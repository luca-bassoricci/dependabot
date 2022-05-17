# frozen_string_literal: true

module Dependabot
  module Dependencies
    # Updated dependency container
    #
    class UpdatedDependency # rubocop:disable Metrics/ClassLength
      # :reek:LongParameterList
      # rubocop:disable Metrics/ParameterLists

      # @param [Dependabot::Dependency] dependency
      # @param [Array<Dependabot::DependencyFile>] dependency_files
      # @param [Integer] state
      # @param [Array<Dependabot::Dependency>] updated_dependencies
      # @param [Array<Dependabot::DependencyFile>] updated_files
      # @param [Boolean] vulnerable
      # @param [Hash] auto_merge_rules
      # @param [Array<Vulnerability>] vulnerabilities
      def initialize(
        dependency:,
        dependency_files:,
        state:,
        updated_dependencies: nil,
        updated_files: nil,
        vulnerable: nil,
        auto_merge_rules: nil,
        vulnerabilities: []
      )
        @dependency = dependency
        @dependency_files = dependency_files
        @state = state
        @updated_dependencies = updated_dependencies
        @updated_files = updated_files
        @vulnerable = vulnerable
        @vulnerabilities = vulnerabilities
        @auto_merge_rules = auto_merge_rules
      end
      # rubocop:enable Metrics/ParameterLists

      # @return [Dependabot::Dependency] main dependency name
      attr_reader :dependency
      # @return [Array<Dependabot::DependencyFile>] dependency files
      attr_reader :dependency_files
      # @return [Integer] update state
      attr_reader :state
      # @return [Array<Dependabot::Dependency>] updated dependencies
      attr_reader :updated_dependencies
      # @return [Array<Dependabot::DependencyFile>] updated files
      attr_reader :updated_files
      # @return [Boolean]
      attr_reader :vulnerable
      # @return [Array<Vulnerability>] vulnerabilities
      attr_reader :vulnerabilities
      # @return [Hash] merge rules
      attr_reader :auto_merge_rules

      delegate :name, to: :dependency

      alias_method :vulnerable?, :vulnerable

      # Main dependency version
      #
      # @return [Object]
      def version
        @version ||= Dependabot::Utils
                     .version_class_for_package_manager(dependency.package_manager)
                     .new(dependency.version)
      end

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

      # Fixed vulnerabilities in format for pr creator
      #
      # @return [Hash]
      def fixed_vulnerabilities
        @fixed_vulnerabilities ||= begin
          fixed = vulnerabilities.select { |entry| updated_dependencies&.any? { |dep| entry.fixed_by?(dep) } }

          # group fixed vulnerabilities by package name
          merge_vulnerabilities(fixed).values.each_with_object(Hash.new { |hsh, key| hsh[key] = [] }) do |vuln, hsh|
            hsh[vuln["package"]] << vuln.except("package")
          end
        end
      end

      # Vulnerabilities that affect dependency
      #
      # @return [Hash]
      def actual_vulnerabilities
        @actual_vulnerabilities ||= vulnerabilities.select { |entry| entry.vulnerable?(version) }
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

      # Object comparator
      # @param [UpdatedDependency] other
      # @return [Booelan]
      def ==(other)
        self.class == other.class && comparable == other.comparable
      end

      protected

      # Object state
      # @return [Array]
      def comparable
        instance_variables.map { |var| instance_variable_get(var) }
      end

      private

      # Convert vulnerability to hash format and merge vulnerabilities with same id
      #
      # @param [Array<Vulnerability>] entries
      # @return [Hash]
      def merge_vulnerabilities(entries)
        entries.each_with_object({}) do |vuln, hsh|
          id = vuln.id

          if hsh.key?(id)
            hsh[id]["patched_versions"] << vuln.first_patched_version if vuln.first_patched_version
            hsh[id]["affected_versions"] << vuln.vulnerable_version_range
            next
          end

          hsh[id] = vuln.to_hash
        end
      end

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
