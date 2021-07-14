# frozen_string_literal: true

module Dependabot
  class DependencyUpdater < ApplicationService
    def initialize(project_name:, config:, fetcher:, repo_contents_path:, name: nil)
      @project_name = project_name
      @config = config
      @fetcher = fetcher
      @name = name
      @repo_contents_path = repo_contents_path
    end

    # Get updated dependency list
    #
    # @return [Array<Dependabot::UpdatedDependency>, Dependabot::UpdatedDependency]
    def call
      name ? single_dependency : dependency_list
    end

    private

    # @return [String]
    attr_reader :project_name
    # @return [Hash]
    attr_reader :config
    # @return [Dependabot::FileFetcher]
    attr_reader :fetcher
    # @return [String]
    attr_reader :name
    # @return [String]
    attr_reader :repo_contents_path

    # Get updated dependency list
    #
    # @return [Array<Dependabot::UpdatedDependency>]
    def dependency_list
      dependencies.map { |dependency| updated_dependencies(dependency) }.compact
    end

    # Get single updated dependency
    #
    # @param [String] name
    # @return [Dependabot::UpdatedDependency]
    def single_dependency
      dependency = dependencies.detect { |dep| dep.name == name }
      raise("#{name} not found in project dependencies") unless dependency

      upd_dependencies = updated_dependencies(dependency)
      raise("Nothing to update! Make sure dependencies are not up to date already!") unless upd_dependencies

      upd_dependencies
    end

    # Dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def dependencies
      @dependencies ||= Dependabot::FileParser.call(
        source: fetcher.source,
        dependency_files: fetcher.files,
        repo_contents_path: repo_contents_path,
        config: config
      )
    end

    # Array of dependencies to update
    #
    # @return [Hash]
    def updated_dependencies(dependency)
      Dependabot::UpdateChecker.call(
        dependency: dependency,
        dependency_files: fetcher.files,
        config: config,
        repo_contents_path: repo_contents_path
      )
    end
  end
end
