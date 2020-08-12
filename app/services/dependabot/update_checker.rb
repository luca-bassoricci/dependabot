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
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      logger.info { "Checking if #{name} needs updating" }
      return log_up_to_date if checker.up_to_date?

      logger.info { "Latest version is #{checker.latest_version}" }
      return updated_dependencies unless requirements_to_unlock == :update_not_possible

      logger.info { "No update possible for #{name}" }
      nil
    end

    private

    # Full dependency name
    #
    # @return [String]
    def name
      @name ||= "#{dependency.name} #{dependency.version}"
    end

    # Print up to date message
    #
    # @return [nil]
    def log_up_to_date
      logger.info { "No update needed for #{dependency.name} #{dependency.version}" }
      nil
    end

    # Get updated dependencies
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
        credentials: Credentials.call
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
  end
end
