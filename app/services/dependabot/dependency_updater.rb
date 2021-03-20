# frozen_string_literal: true

module Dependabot
  class DependencyUpdater < ApplicationService
    def initialize(project_name, config, fetcher)
      @project_name = project_name
      @config = config
      @fetcher = fetcher
    end

    # Get updated dependency list
    #
    # @return [Array<Dependabot::UpdatedDependency>]
    def call
      dependencies.map do |dependency|
        updated_deps = updated_dependencies(dependency)
        next unless updated_deps

        UpdatedDependency.new(
          name: dependency.name,
          updated_files: updated_files(updated_deps[:updated_dependencies]),
          **updated_deps
        )
      end.compact
    end

    # Get single updated dependency
    #
    # @param [String] name
    # @return [Dependabot::UpdatedDependency]
    def updated_depedency(name)
      dep = dependencies.detect { |dependency| dependency.name == name }
      raise "#{name} not found in project dependencies" unless dep

      dependencies = updated_dependencies(dep)
      UpdatedDependency.new(
        name: dep.name,
        updated_files: updated_files(dependencies[:dependencies]),
        **dependencies
      )
    end

    private

    # @return [String]
    attr_reader :project_name
    # @return [Hash]
    attr_reader :config
    # @return [Dependabot::FileFetcher]
    attr_reader :fetcher

    # Package manager name
    #
    # @return [String]
    def package_manager
      @package_manager ||= config[:package_manager]
    end

    # Dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def dependencies
      @dependencies ||= Dependabot::FileParser.call(
        source: fetcher.source,
        dependency_files: fetcher.files,
        package_manager: package_manager
      )
    end

    # Array of dependencies to update
    #
    # @return [Hash]
    def updated_dependencies(dependency)
      Dependabot::UpdateChecker.call(
        dependency: dependency,
        dependency_files: fetcher.files,
        allow: config[:allow],
        ignore: config[:ignore],
        versioning_strategy: config[:versioning_strategy]
      )
    end

    # Array of updated files
    #
    # @return [Array<Dependabot::DependencyFile>]
    def updated_files(updated_dependencies)
      Dependabot::FileUpdater.call(
        dependencies: updated_dependencies,
        dependency_files: fetcher.files,
        package_manager: package_manager
      )
    end
  end
end
