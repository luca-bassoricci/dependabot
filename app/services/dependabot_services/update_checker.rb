# frozen_string_literal: true

module DependabotServices
  class UpdateChecker < ApplicationService
    # Get update checker
    # @param [Dependabot::Dependency] dependency
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @param [String] package_manager <description>
    # @return [Dependabot::UpdateChecker]
    def call(dependency:, dependency_files:)
      Dependabot::UpdateCheckers.for_package_manager(dependency.package_manager).new(
        dependency: dependency,
        dependency_files: dependency_files,
        credentials: Credentials.call
      )
    end
  end
end
