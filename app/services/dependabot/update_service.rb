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

    delegate :configuration, to: :project, prefix: :project
    delegate :standalone?, to: "AppConfig"

    attr_reader :project_name,
                :package_ecosystem,
                :directory,
                :dependency_name

    # Project
    #
    # @return [Project]
    def project
      @project ||= begin
        return standalone_project if standalone?

        # Fetch config from Gitlab if deployment is not integrated with webhooks to make sure it is up to date
        Project.find_by(name: project_name).tap do |existing_project|
          existing_project.configuration = config unless AppConfig.integrated?
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
      Project.new(name: project_name, configuration: config, forked_from_id: fork_id)
    end

    # Open mr limits
    #
    # @return [Number]
    def limits
      @limits ||= {
        mr: config_entry[:open_merge_requests_limit],
        security_mr: 10
      }
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
      @config_entry ||= project_configuration
                        .entry(package_ecosystem: package_ecosystem, directory: directory)
                        .tap { |entry| raise_missing_entry_error unless entry }
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

    # Get file fetcher
    #
    # @return [Dependabot::FileFetcher]
    def fetcher
      @fetcher ||= Files::Fetcher.call(
        project_name: project_name,
        config_entry: config_entry,
        registries: registries,
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
          registries: registries
        )
        dependency_name ? deps.select { |dep| dep.name == dependency_name } : deps
      end
    end

    # Update project dependencies
    #
    # @return [void]
    def update
      dependencies.each_with_object({ mr: Set.new, security_mr: Set.new }) do |dep, count|
        updated_dep = updated_dependency(dep)
        next update_dependency(updated_dep, count) if updated_dep.updates?
        next if standalone?

        if config_entry.dig(:vulnerability_alerts, :enabled)
          create_vulnerability_issues(updated_dep) if updated_dep.vulnerable?
          close_obsolete_vulnerability_issues(updated_dep)
        end

        close_obsolete_mrs(updated_dep.name)
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
        registries: registries
      )
    end

    # Create dependency update merge request
    #
    # @param [Dependabot::Dependencies::UpdatedDependency] updated_dependency
    # @param [Hash] mrs
    # @return [void]
    def update_dependency(dependency, mrs)
      type = dependency.vulnerable ? :security_mr : :mr
      skip_message = <<~LOG.strip
        skipping update of #{type == :mr ? '' : 'vulnerable '}dependency due to max #{limits[type]} open mr limit!
      LOG

      return log(:info, "  #{skip_message}") if mrs[type].length >= limits[type]

      iid = MergeRequest::CreateService.call(
        project: project,
        fetcher: fetcher,
        config_entry: config_entry,
        updated_dependency: dependency
      )&.iid

      mrs[type] << iid if iid
    end

    # Close obsolete merge requests
    #
    # @param [String] dependency_name
    # @return [void]
    def close_obsolete_mrs(dependency_name)
      obsolete_mrs = project.open_dependency_merge_requests(dependency_name, directory)

      return if obsolete_mrs.length.zero?

      obsolete_mrs.each do |mr|
        log(:debug, "Closing obsolete merge request !#{mr.iid} because dependency version is up to date")
        mr.close
        Gitlab::BranchRemover.call(project_name, mr.branch)
      rescue StandardError => e
        log_error(e)
      end
    end

    # Create security vulnerability alert issues
    #
    # @param [Dependabot::Dependencies::UpdatedDependency] dependency
    # @return [void]
    def create_vulnerability_issues(dependency)
      dependency.actual_vulnerabilities.each do |vulnerability|
        Gitlab::Vulnerabilities::IssueCreator.call(
          project: project,
          vulnerability: vulnerability,
          dependency_file: dependency.dependency_files.reject(&:support_file).first,
          assignees: config_entry.dig(:vulnerability_alerts, :assignees)
        )
      end
    end

    # Close obsolete vulnerability alerts
    #
    # @param [Dependabot::Dependencies::UpdatedDependency] dependency
    # @return [void]
    def close_obsolete_vulnerability_issues(dependency)
      VulnerabilityIssue
        .open_vulnerability_issues(
          package_ecosystem: package_ecosystem,
          directory: directory,
          package: dependency.name
        )
        .reject { |issue| issue.vulnerability.vulnerable?(dependency.version) }
        .each { |issue| Gitlab::Vulnerabilities::IssueCloser.call(issue) }
    end

    # Raise config missing specific entry error
    #
    # @return [void]
    def raise_missing_entry_error
      raise("Configuration missing entry with package-ecosystem: #{package_ecosystem}, directory: #{directory}")
    end
  end
end
