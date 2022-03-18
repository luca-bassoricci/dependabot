# frozen_string_literal: true

module Dependabot
  module Dependencies
    # :reek:TooManyStatements

    # Checker class for new version availability
    #
    class UpdateChecker < ApplicationService # rubocop:disable Metrics/ClassLength
      using Rainbow

      HAS_UPDATES = 1
      UP_TO_DATE = 2
      UPDATE_IMPOSSIBLE = 3
      SKIPPED = 4
      ERROR = 5

      # @param [Dependabot::Dependency] dependency
      # @param [Array<Dependabot::DependencyFile>] dependency_files
      # @param [Hash] config_entry
      # @param [String] repo_contents_path
      # @param [Array<Hash>] registries
      def initialize(dependency:, dependency_files:, config_entry:, repo_contents_path:, registries:)
        @dependency = dependency
        @dependency_files = dependency_files
        @config_entry = config_entry
        @versioning_strategy = config_entry[:versioning_strategy]
        @package_manager = config_entry[:package_manager]
        @repo_contents_path = repo_contents_path
        @registries = registries
      end

      delegate :name, to: :dependency, prefix: :dependency

      # Get updated dependencies
      #
      # @return [Dependabot::UpdatedDependency, nil]
      def call
        return skipped unless rule_handler.allowed?

        log(:info, "Fetching info for #{dependency_name.bright}")
        return up_to_date if checker.up_to_date?
        return update_impossible if requirements_to_unlock == :update_not_possible

        updated_dependency
      rescue Dependabot::AllVersionsIgnored
        log(
          :info,
          "  skipping #{dependency.name.bright} update due to ignored versions rule: #{checker.ignored_versions}"
        )
        UpdatedDependency.new(name: dependency_name, state: SKIPPED)
      rescue StandardError => e
        log_error(e)
        capture_error(e)
        UpdatedDependency.new(name: dependency_name, state: ERROR)
      end

      private

      attr_reader :dependency,
                  :dependency_files,
                  :config_entry,
                  :versioning_strategy,
                  :package_manager,
                  :repo_contents_path,
                  :registries

      # Fetch combined credentials
      #
      # @return [Array<Hash>]
      def credentials
        @credentials ||= [*Credentials.call, *registries]
      end

      # Dependency name with version
      #
      # @return [String]
      def name
        @name ||= "#{dependency_name}: #{dependency.version}".bright
      end

      # Rule handler
      #
      # @return [RuleHandler]
      def rule_handler
        @rule_handler ||= RuleHandler.new(
          dependency: dependency,
          checker: checker,
          config_entry: config_entry
        )
      end

      # Print skipped message
      #
      # @return [nil]
      def skipped
        log(:debug, "Skipping '#{name}' due to allow rules: #{config_entry[:allow]}")
        UpdatedDependency.new(name: dependency.name, state: SKIPPED)
      end

      # Print up to date message
      #
      # @return [nil]
      def up_to_date
        log(:info, "  #{name} is up to date")
        UpdatedDependency.new(name: dependency.name, state: UP_TO_DATE)
      end

      # Print update impossible message
      #
      # @return [nil]
      def update_impossible
        log(:warn, "  update for '#{name}' is impossible")
        unless checker.conflicting_dependencies.empty?
          log(:warn, "  following conflicting dependencies are present: #{checker.conflicting_dependencies}")
        end
        UpdatedDependency.new(name: dependency.name, state: UPDATE_IMPOSSIBLE)
      end

      # Versioning strategy set to lock file only
      #
      # @return [Boolean]
      def lockfile_only?
        versioning_strategy == :lockfile_only
      end

      # Get filtered updated dependencies
      #
      # @return [Dependabot::UpdatedDependency]
      def updated_dependency
        log(:info, "  updating #{name} => #{checker.latest_version.to_s.bright}")
        updated_dependencies = checker.updated_dependencies(requirements_to_unlock: requirements_to_unlock)

        UpdatedDependency.new(
          name: dependency.name,
          state: HAS_UPDATES,
          updated_dependencies: updated_dependencies,
          updated_files: updated_files(updated_dependencies),
          vulnerable: checker.vulnerable?,
          security_advisories: checker.security_advisories,
          auto_merge_rules: config_entry[:auto_merge]
        )
      end

      # Get update checker
      #
      # @return [Dependabot::UpdateChecker]
      def checker
        @checker ||= begin
          args = {
            dependency: dependency,
            dependency_files: dependency_files,
            credentials: credentials,
            ignored_versions: RuleHandler.version_conditions(dependency, config_entry[:ignore]),
            raise_on_ignored: true
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

      # Array of updated files
      #
      # @return [Array<Dependabot::DependencyFile>]
      def updated_files(updated_dependencies)
        Dependabot::Files::Updater.call(
          dependencies: updated_dependencies,
          dependency_files: dependency_files,
          package_manager: package_manager,
          repo_contents_path: repo_contents_path,
          credentials: credentials
        )
      end
    end
  end
end
