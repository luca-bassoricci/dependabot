# frozen_string_literal: true

module Dependabot
  # :reek:InstanceVariableAssumption

  # Main entrypoint class for updating dependencies and creating merge requests
  #
  class UpdateService < ApplicationService
    # @param [Hash<String, Object>] args
    def initialize(args)
      @project_name = args[:project_name]
      @package_ecosystem = args[:package_ecosystem]
      @directory = args[:directory]
      @dependency_name = args[:dependency_name]
    end

    # Create or update mr's for dependencies
    #
    # @return [void]
    def call # rubocop:disable Metrics/MethodLength
      fetch_config

      Semaphore.synchronize do
        update_security_vulnerabilities
        update_dependencies
      end
    rescue Octokit::TooManyRequests
      raise(<<~ERR)
        github API rate limit exceeded! See: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting
      ERR
    rescue Dependabot::UnexpectedExternalCode
      raise(<<~ERR)
        Unexpected external code execution detected.
        Option 'insecure-external-code-execution' must be set to 'allow' for package_ecosystem '#{package_ecosystem}'
      ERR
    ensure
      FileUtils.rm_r(repo_contents_path, force: true, secure: true) if repo_contents_path
    end

    private

    attr_reader :project_name,
                :package_ecosystem,
                :directory,
                :config,
                :dependency_name

    # Get cloned repository path
    #
    # @return [String]
    def repo_contents_path
      return @repo_contents_path if defined?(@repo_contents_path)

      @repo_contents_path = DependabotCoreHelper.repo_contents_path(project_name, config)
    end

    # Fetch config for project
    #
    # @return [Hash]
    def fetch_config
      config_entry = Dependabot::Config::Fetcher.call(
        project_name,
        find_by: {
          package_ecosystem: package_ecosystem,
          directory: directory
        }
      )
      raise("Configuration missing entry with package-ecosystem: #{package_ecosystem}") unless config_entry

      @config = config_entry
    end

    # Project
    #
    # @return [Project]
    def project
      return Project.find_by(name: project_name) unless AppConfig.standalone

      Project.new(
        name: project_name,
        forked_from_id: config[:fork] ? gitlab.project(project_name).to_h.dig("forked_from_project", "id") : nil
      )
    end

    # Package manager name
    #
    # @return [String]
    def package_manager
      @package_manager ||= config[:package_manager]
    end

    # Get file fetcher
    #
    # @return [Dependabot::FileFetcher]
    def fetcher
      @fetcher ||= Dependabot::Files::Fetcher.call(project_name, config, repo_contents_path)
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
          config: config,
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

        break if mr_count >= config[:open_merge_requests_limit]

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
        config: config,
        updated_dependency: updated_dependency
      )
    end
  end
end
