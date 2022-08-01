# frozen_string_literal: true

module Dependabot
  # :reek:InstanceVariableAssumption

  # Base class for dependency updater implementations
  #
  class UpdateBase < ApplicationService
    def initialize(project_name)
      @project_name = project_name
    end

    private

    delegate :configuration, to: :project, prefix: :project

    attr_reader :project_name

    # Project
    #
    # @return [Project]
    def project
      Project.find_by(name: project_name)
    end

    # Set gitlab client token
    #
    # @return [void]
    def init_gitlab
      Gitlab::ClientWithRetry.client_access_token = project.gitlab_access_token
    end

    # All project dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def dependencies
      @dependencies ||= begin
        deps = Files::Parser.call(
          source: fetcher.source,
          dependency_files: fetcher.files,
          repo_contents_path: repo_contents_path,
          config_entry: config_entry,
          credentials: credentials
        )
        dependency_name ? deps.select { |dep| dep.name == dependency_name } : deps
      end
    end

    # Array of dependencies to update
    #
    # @return [Dependabot::Dependencies::UpdatedDependency]
    def updated_dependency(dependency)
      Dependencies::UpdateChecker.call(
        dependency: dependency,
        dependency_files: fetcher.files,
        config_entry: config_entry,
        repo_contents_path: repo_contents_path,
        credentials: credentials
      )
    end

    # Get file fetcher
    #
    # @return [Dependabot::FileFetcher]
    def fetcher
      @fetcher ||= Files::Fetcher.call(
        project_name: project_name,
        config_entry: config_entry,
        credentials: credentials,
        repo_contents_path: repo_contents_path
      )
    end

    # Get cloned repository path
    #
    # @return [String]
    def repo_contents_path
      return @repo_contents_path if defined?(@repo_contents_path)

      @repo_contents_path = DependabotCoreHelper.repo_contents_path(project_name, config_entry)
    end

    # Config entry for specific package ecosystem and directory
    #
    # @return [Hash]
    def config_entry(config = project_configuration)
      @config_entry ||= config
                        .entry(package_ecosystem: package_ecosystem, directory: directory)
                        .tap { |entry| raise_missing_entry_error unless entry }
    end

    # Combined credentials
    #
    # @return [Array<Hash>]
    def credentials
      @credentials ||= [
        *Credentials.call(project.gitlab_access_token),
        *registries
      ]
    end

    # Allowed private registries
    #
    # @return [Array<Hash>]
    def registries
      @registries ||= project_configuration.allowed_registries(
        package_ecosystem: package_ecosystem,
        directory: directory
      )
    end

    # Raise config missing specific entry error
    #
    # @return [void]
    def raise_missing_entry_error
      raise("Configuration is missing entry with package-ecosystem: #{package_ecosystem}, directory: #{directory}")
    end
  end
end
