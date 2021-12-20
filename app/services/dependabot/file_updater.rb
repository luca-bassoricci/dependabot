# frozen_string_literal: true

module Dependabot
  class FileUpdater < ApplicationService
    # @param [Array<Dependabot::Dependency>] dependencies
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @param [String] package_manager
    def initialize(dependencies:, dependency_files:, package_manager:, repo_contents_path:, credentials:)
      @dependencies = dependencies
      @dependency_files = dependency_files
      @package_manager = package_manager
      @repo_contents_path = repo_contents_path
      @credentials = credentials
    end

    # Get update checker
    #
    # @return [Array<Dependabot::DependencyFile>]
    def call
      Dependabot::FileUpdaters.for_package_manager(package_manager).new(
        dependencies: dependencies,
        dependency_files: dependency_files,
        credentials: credentials,
        repo_contents_path: repo_contents_path
      ).updated_dependency_files
    end

    private

    attr_reader :dependencies, :dependency_files, :package_manager, :repo_contents_path, :credentials
  end
end
