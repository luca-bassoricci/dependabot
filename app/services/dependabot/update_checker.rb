# frozen_string_literal: true

module Dependabot
  class UpdateChecker < ApplicationService
    attr_reader :dependency, :dependency_files

    # @param [Dependabot::Dependency] dependency
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    def initialize(dependency:, dependency_files:)
      @dependency = dependency
      @dependency_files = dependency_files
    end

    # Get update checker
    # @return [Array<Dependabot::Dependency>]
    def call
      logger.info { "Checking if #{dependency.name} #{dependency.version} needs updating" }
      return checker.updated_dependencies(requirements_to_unlock: requirements_to_unlock) unless update_impossible?

      log_no_update_reason
      nil
    end

    private

    # @return [Dependabot::UpdateChecker]
    def checker
      @checker ||= Dependabot::UpdateCheckers.for_package_manager(dependency.package_manager).new(
        dependency: dependency,
        dependency_files: dependency_files,
        credentials: Credentials.call
      )
    end

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

    # @return [Boolean]
    def update_impossible?
      checker.up_to_date? || requirements_to_unlock == :update_not_possible
    end

    # @return [void]
    def log_no_update_reason
      return logger.info { "Latest version is #{dependency.version}" } if checker.up_to_date?

      logger.info { "Requirements to unlock #{requirements_to_unlock}" }
      logger.info { "No update possible for #{dependency.name} #{dependency.version}" }
    end
  end
end
