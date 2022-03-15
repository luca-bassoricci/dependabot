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
  class UpdateService < ApplicationService # rubocop:disable Metrics/ClassLength
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
      Semaphore.synchronize { update }
    rescue Octokit::TooManyRequests
      raise TooManyRequestsError
    rescue Dependabot::UnexpectedExternalCode
      raise ExternalCodeExecutionError.new(package_ecosystem, directory)
    ensure
      FileUtils.rm_r(repo_contents_path, force: true, secure: true) if repo_contents_path
    end

    private

    attr_reader :project_name, :package_ecosystem, :directory, :dependency_name

    # Project
    #
    # @return [Project]
    def project
      @project ||= begin
        return standalone_project if AppConfig.standalone?

        # Fetch config from Gitlab if deployment is not integrated with webhooks to make sure it is up to date
        Project.find_by(name: project_name).tap do |existing_project|
          existing_project.config = config unless AppConfig.integrated?
        end
      end
    end

    # Non persisted project for standalone run
    #
    # @return [Project]
    def standalone_project
      @config_entry = config.entry(package_ecosystem: package_ecosystem, directory: directory)
      raise_missing_entry_error unless @config_entry

      fork_id = config_entry[:fork] ? gitlab.project(project_name).to_h.dig("forked_from_project", "id") : nil
      Project.new(name: project_name, config: config, forked_from_id: fork_id)
    end

    # Open mr limit
    #
    # @return [Number]
    def mr_limit
      @mr_limit ||= config_entry[:open_merge_requests_limit]
    end

    # Project configuration fetched from gitlab
    #
    # @return [Config]
    def config
      @config ||= Config::Fetcher.call(project_name)
    end

    # Config entry for specific package ecosystem and directory
    #
    # @return [Hash]
    def config_entry
      @config_entry ||= project.config.entry(package_ecosystem: package_ecosystem, directory: directory).tap do |entry|
        raise_missing_entry_error unless entry
      end
    end

    # Get file fetcher
    #
    # @return [Dependabot::FileFetcher]
    def fetcher
      @fetcher ||= Files::Fetcher.call(project_name, config_entry, repo_contents_path)
    end

    # Get cloned repository path
    #
    # @return [String]
    def repo_contents_path
      return @repo_contents_path if defined?(@repo_contents_path)

      @repo_contents_path = DependabotCoreHelper.repo_contents_path(project_name, config_entry)
    end

    # Update project dependencies
    #
    # @return [void]
    def update
      dependencies.each_with_object({ mr: Set.new, security_mr: Set.new }) do |dep, count|
        break if count[:security_mr].length >= 10 && count[:mr].length >= mr_limit

        updated_dep = updated_dependency(dep)
        close_obsolete_mrs(dep.name) if updated_dep.up_to_date?
        next unless updated_dep.updates?

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
    # @param [Hash] mrs
    # @return [void]
    def update_vulnerable_dependency(updated_dependency, mrs)
      if mrs[:security_mr].length >= 10
        return log(:info, " skipping update of vulnerable dependency due to max 10 open mr limit!")
      end

      iid = create_mr(updated_dependency)&.iid
      mrs[:security_mr] << iid if iid
    end

    # Update dependency
    #
    # @param [Dependabot::UpdatedDependency] updated_dependency
    # @param [Hash] mrs
    # @return [void]
    def update_dependency(updated_dependency, mrs)
      if mrs[:mr].length >= mr_limit
        return log(:info, "  skipping update of dependency due to max #{mr_limit} open mr limit!")
      end

      iid = create_mr(updated_dependency)&.iid
      mrs[:mr] << iid if iid
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
          config: config_entry
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
        config: config_entry,
        repo_contents_path: repo_contents_path
      )
    end

    # Close obsolete merge requests
    #
    # @param [String] dependency_name
    # @return [void]
    def close_obsolete_mrs(dependency_name)
      return if AppConfig.standalone?

      obsolete_mrs = project.merge_requests
                            .where(main_dependency: dependency_name, state: "opened")
                            .compact

      return if obsolete_mrs.length.zero?

      obsolete_mrs.each do |mr|
        log(:info, "  closing obsolete merge request !#{mr.iid} because dependency version is up to date")
        mr.close
        Gitlab::BranchRemover.call(project_name, mr.branch)
      rescue StandardError => e
        log_error(e)
      end
    end

    # Create or update merge request
    #
    # @param [Dependabot::Dependencies::UpdatedDependency] updated_dep
    # @return [Gitlab::ObjectifiedHash]
    def create_mr(updated_dep)
      MergeRequest::CreateService.call(
        project: project,
        fetcher: fetcher,
        config: config_entry,
        updated_dependency: updated_dep
      )
    end

    # Raise config missing specific entry error
    #
    # @return [void]
    def raise_missing_entry_error
      raise("Configuration missing entry with package-ecosystem: #{package_ecosystem}, directory: #{directory}")
    end
  end
end
