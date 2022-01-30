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

      Semaphore.synchronize do
        update_security_vulnerabilities
        update_dependencies
      end
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

    # All security updates
    #
    # @return [Array]
    def all_vulnerable_dependencies
      @all_vulnerable_dependencies ||= all_updated_dependencies.select(&:vulnerable)
    end

    # All dependencies for update
    #
    # @return [Array<Dependabot::UpdatedDependency>]
    def all_updated_dependencies
      @all_updated_dependencies ||= begin
        dependencies = Dependabot::DependencyUpdater.call(
          project_name: project_name,
          config: config_entry,
          fetcher: fetcher,
          repo_contents_path: repo_contents_path,
          name: dependency_name
        )

        dependency_name ? [dependencies].compact : dependencies
      end
    end

    # Run updates for vulnerable dependencies
    #
    # @return [void]
    def update_security_vulnerabilities
      all_vulnerable_dependencies.reduce(0) do |mr_count, dep|
        mr_count += 1 if create_mr(dep)

        break if mr_count >= 10

        mr_count
      end
    end

    # Update rest of the dependencies
    #
    # @return [void]
    def update_dependencies
      (all_updated_dependencies - all_vulnerable_dependencies).reduce(0) do |mr_count, dep|
        mr_count += 1 if create_mr(dep)

        break if mr_count >= config_entry[:open_merge_requests_limit]

        mr_count
      end
    end

    # Create or update merge request
    #
    # @param [Dependabot::UpdatedDependency] updated_dependency
    # @return [Gitlab::ObjectifiedHash]
    def create_mr(updated_dependency)
      Dependabot::MergeRequest::CreateService.call(
        project: project,
        fetcher: fetcher,
        config: config_entry,
        updated_dependency: updated_dependency
      )
    end
  end
end
