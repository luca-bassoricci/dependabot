# frozen_string_literal: true

module Dependabot
  class TooManyRequestsError < StandardError
    def message
      "GitHub API rate limit exceeded! See: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting"
    end
  end

  class ExternalCodeExecutionError < StandardError
    def initialize(package_ecosystem, directory)
      super(<<~ERR)
        Unexpected external code execution detected.
        Option 'insecure-external-code-execution' must be set to 'allow' for entry:
          package_ecosystem - '#{package_ecosystem}'
          directory - '#{directory}'
      ERR
    end
  end

  # :reek:InstanceVariableAssumption

  # Main entrypoint class for updating dependencies and creating merge requests
  #
  class UpdateService < ApplicationService
    def initialize(args)
      @project_name = args[:project_name]
      @package_ecosystem = args[:package_ecosystem]
      @directory = args[:directory]
      @dependency_name = args[:dependency_name]
    end

    # Create or update mr's for dependencies
    #
    # @return [void]
    def call
      fetch_config
      set_fork

      Semaphore.synchronize { update }
    rescue Octokit::TooManyRequests
      raise TooManyRequestsError
    rescue Dependabot::UnexpectedExternalCode
      raise ExternalCodeExecutionError.new(package_ecosystem, directory)
    ensure
      FileUtils.rm_r(repo_contents_path, force: true, secure: true) if repo_contents_path
    end

    private

    attr_reader :project_name,
                :package_ecosystem,
                :directory,
                :config_entry,
                :dependency_name

    # Open mr limit
    #
    # @return [Number]
    def mr_limit
      @mr_limit ||= config_entry[:open_merge_requests_limit]
    end

    # Project
    #
    # @return [Project]
    def project
      @project ||= AppConfig.standalone ? Project.new(name: project_name) : Project.find_by(name: project_name)
    end

    # Get file fetcher
    #
    # @return [Dependabot::FileFetcher]
    def fetcher
      @fetcher ||= Dependabot::Files::Fetcher.call(project_name, config_entry, repo_contents_path)
    end

    # Get cloned repository path
    #
    # @return [String]
    def repo_contents_path
      return @repo_contents_path if defined?(@repo_contents_path)

      @repo_contents_path = DependabotCoreHelper.repo_contents_path(project_name, config_entry)
    end

    # Fetch config entry for project
    #
    # @return [Hash]
    def fetch_config
      config = project.config.empty? ? Dependabot::Config::Fetcher.call(project_name) : project.config
      entry = config.entry(package_ecosystem: package_ecosystem, directory: directory)
      unless entry
        raise("Configuration missing entry with package-ecosystem: #{package_ecosystem}, directory: #{directory}")
      end

      @config_entry = entry
    end

    # Set fork id
    #
    # @return [void]
    def set_fork
      return unless config_entry[:fork] && !project.forked_from_id

      project.forked_from_id = gitlab.project(project_name).to_h.dig("forked_from_project", "id")
    end

    # Update project dependencies
    #
    # @return [void]
    def update
      dependencies.each_with_object({ mr: 0, security_mr: 0 }) do |dep, count|
        break if count[:security_mr] >= 10 && count[:mr] >= mr_limit

        updated_dep = updated_dependency(dep)
        next unless updated_dep

        if updated_dep.vulnerable
          update_vulnerable_dependency(updated_dep, count)
        else
          update_dependency(updated_dep, count)
        end
      end
    end

    # Update vulnerable dependency
    #
    # @param [Dependabot::UpdatedDependency] updated_dependency
    # @param [Hash] mr_count
    # @return [void]
    def update_vulnerable_dependency(updated_dependency, mr_count)
      if mr_count[:security_mr] >= 10
        return log(:info, " skipping update of vulnerable dependency due to max 10 open mr limit!")
      end

      mr_count[:security_mr] += 1 if create_mr(updated_dependency)
    end

    # Update dependency
    #
    # @param [Dependabot::UpdatedDependency] updated_dependency
    # @param [Hash] mr_count
    # @return [void]
    def update_dependency(updated_dependency, mr_count)
      if mr_count[:mr] >= mr_limit
        return log(:ingo, " skipping update of dependency due to max #{mr_limit} open mr limit!")
      end

      mr_count[:mr] += 1 if create_mr(updated_dependency)
    end

    # All project dependencies
    #
    # @return [Array<Dependabot::Dependency>]
    def dependencies
      @dependencies ||= begin
        deps = Dependabot::Files::Parser.call(
          source: fetcher.source,
          dependency_files: fetcher.files,
          repo_contents_path: repo_contents_path,
          config: config_entry
        )
        dependency_name ? deps.select { |dep| dep.name == dependency_name } : deps
      end
    end

    # Array of dependencies to update
    #
    # @return [Dependabot::UpdatedDependency]
    def updated_dependency(dependency)
      Dependabot::UpdateChecker.call(
        dependency: dependency,
        dependency_files: fetcher.files,
        config: config_entry,
        repo_contents_path: repo_contents_path
      )
    end

    # Create or update merge request
    #
    # @param [Dependabot::UpdatedDependency] updated_dep
    # @return [Gitlab::ObjectifiedHash]
    def create_mr(updated_dep)
      Dependabot::MergeRequest::CreateService.call(
        project: project,
        fetcher: fetcher,
        config: config_entry,
        updated_dependency: updated_dep
      )
    end
  end
end
