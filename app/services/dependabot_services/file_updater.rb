# frozen_string_literal: true

module DependabotServices
  class FileUpdater < ApplicationService
    # Get update checker
    # @param [Array<Dependabot::Dependency>] dependencies
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @return [Dependabot::UpdateChecker]
    def call(dependencies:, dependency_files:)
      Dependabot::FileUpdaters.for_package_manager(dependencies.first.package_manager).new(
        dependencies: dependencies,
        dependency_files: dependency_files,
        credentials: Credentials.call
      )
    end
  end
end
