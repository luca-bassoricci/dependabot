# frozen_string_literal: true

module Dependabot
  # :reek:InstanceVariableAssumption
  class UpdateService < ApplicationService
    # @param [Hash<String, Object>] args
    def initialize(args)
      @project_name, @package_ecosystem, @directory = args.values_at("repo", "package_ecosystem", "directory")
    end

    # Create or update mr's for dependencies
    #
    # @return [void]
    def call
      fetch_config

      Semaphore.synchronize do
        update_security_vulnerabilities
        update_dependencies
      end
    rescue Octokit::TooManyRequests
      log(:error, "github API rate limit exceeded! See: https://developer.github.com/v3/#rate-limiting")
    ensure
      # TODO: See if it's possible to update core with pulling in to already cloned repo to not clone new copy each time
      FileUtils.rm_r(repo_contents_path, force: true, secure: true) if repo_contents_path
    end

    private

    attr_reader :project_name, :package_ecosystem, :directory, :config

    # Get cloned repository path
    #
    # @return [String]
    def repo_contents_path
      return @repo_contents_path if defined?(@repo_contents_path)

      @repo_contents_path = DependabotHelper.repo_contents_path(project_name, config)
    end

    # Fetch config for project
    #
    # @return [Hash]
    def fetch_config
      config_entry = Dependabot::Config.call(
        project_name,
        find_by: {
          package_ecosystem: package_ecosystem,
          directory: directory
        }
      )
      raise("Configuration missing entry with package-ecosystem: #{package_ecosystem}") unless config_entry

      @config = config_entry
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
      @fetcher ||= Dependabot::FileFetcher.call(project_name, config, repo_contents_path)
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
      @all_updated_dependencies ||= Dependabot::DependencyUpdater.call(
        project_name: project_name,
        config: config,
        fetcher: fetcher,
        repo_contents_path: repo_contents_path
      )
    end

    # Run updates for vulnerable dependencies
    #
    # @return [void]
    def update_security_vulnerabilities
      all_vulnerable_dependencies.each_with_index do |dep, index|
        break if index >= 10

        create_mr(dep)
      end
    end

    # Update rest of the dependencies
    #
    # @return [void]
    def update_dependencies
      (all_updated_dependencies - all_vulnerable_dependencies).each_with_index do |dep, index|
        break if index >= config[:open_merge_requests_limit]

        create_mr(dep)
      end
    end

    # Create or update merge request
    #
    # @param [Dependabot::UpdatedDependency] updated_dependency
    # @return [Gitlab::ObjectifiedHash]
    def create_mr(updated_dependency)
      Dependabot::MergeRequestService.call(
        project: AppConfig.standalone ? nil : Project.find_by(name: project_name),
        fetcher: fetcher,
        config: config,
        updated_dependency: updated_dependency
      )
    end
  end
end
