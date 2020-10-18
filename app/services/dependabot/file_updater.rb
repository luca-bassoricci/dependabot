# frozen_string_literal: true

module Dependabot
  class FileUpdater < ApplicationService
    # @param [Array<Dependabot::Dependency>] dependencies
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @param [String] package_manager
    def initialize(dependencies:, dependency_files:, package_manager:)
      @dependencies = dependencies
      @dependency_files = dependency_files
      @package_manager = package_manager
    end

    # Get update checker
    #
    # @return [Array<Dependabot::DependencyFile>]
    def call
      mutex.synchronize do
        Dependabot::FileUpdaters.for_package_manager(package_manager).new(
          dependencies: dependencies,
          dependency_files: dependency_files,
          credentials: Credentials.fetch
        ).updated_dependency_files
      end
    end

    private

    attr_reader :dependencies, :dependency_files, :package_manager, :semaphore
  end
end
