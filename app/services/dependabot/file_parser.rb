# frozen_string_literal: true

module Dependabot
  class FileParser < ApplicationService
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @param [Dependabot::Source] source
    # @param [String] package_manager
    def initialize(dependency_files:, source:, package_manager:, repo_contents_path:)
      @dependency_files = dependency_files
      @source = source
      @package_manager = package_manager
      @repo_contents_path = repo_contents_path
    end

    # Get parsed dependencies from files
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      Dependabot::FileParsers.for_package_manager(package_manager).new(
        dependency_files: dependency_files,
        source: source,
        credentials: Credentials.call,
        repo_contents_path: repo_contents_path
      ).parse
    end

    private

    attr_reader :dependency_files, :source, :package_manager, :repo_contents_path
  end
end
