# frozen_string_literal: true

class DependencyUpdater < ApplicationService
  # @param [Hash<String, Object>] args
  def initialize(args)
    @project_name, @package_ecosystem, @directory = args.values_at("repo", "package_ecosystem", "directory")
  end

  # Create or update mr's for dependencies
  #
  # @return [void]
  def call
    update_security_vulnerabilities
    update_dependencies
  rescue Octokit::TooManyRequests
    logger.error { "github API rate limit exceeded! See: https://developer.github.com/v3/#rate-limiting" }
  end

  private

  attr_reader :project_name, :package_ecosystem, :directory

  # Dependabot config
  #
  # @return [Hash]
  def config
    @config ||= begin
      config_entry = Dependabot::Config.call(project_name, default_branch).find do |conf|
        conf[:package_ecosystem] == package_ecosystem && conf[:directory] == directory
      end
      raise("Configuration missing entry with package-ecosystem: #{package_ecosystem}") unless config_entry

      config_entry
    end
  end

  # Project default branch
  #
  # @return [String]
  def default_branch
    Gitlab::DefaultBranch.call(project_name)
  end

  # Package manager name
  #
  # @return [String]
  def package_manager
    @package_manager ||= config[:package_manager]
  end

  # Persisted project
  #
  # @return [Project]
  def project
    @project ||= AppConfig.standalone ? nil : Project.find_by(name: project_name)
  end

  # Get file fetcher
  #
  # @return [Dependabot::FileFetcher]
  def fetcher
    @fetcher ||= Dependabot::FileFetcher.call(
      package_manager: package_manager,
      source: Dependabot::DependabotSource.call(
        repo: project_name,
        branch: config[:branch],
        directory: config[:directory]
      )
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

  # All security updates
  #
  # @return [Array]
  def all_vulnerable_dependencies
    @all_vulnerable_dependencies ||= all_updated_dependencies.select { |dep| dep[:vulnerable] }
  end

  # All dependencies for update
  #
  # @return [Array]
  def all_updated_dependencies
    @all_updated_dependencies ||= dependencies.map { |dep| updated_dependencies(dep) }.compact
  end

  # Dependencies
  #
  # @return [Array<Dependabot::Dependency>]
  def dependencies
    @dependencies ||= Semaphore.synchronize do
      Dependabot::FileParser.call(
        source: fetcher.source,
        dependency_files: fetcher.files,
        package_manager: package_manager
      )
    end
  end

  # Array of updated dependencies
  #
  # @return [Array<Dependabot::Dependency>]
  def updated_dependencies(dependency)
    Semaphore.synchronize do
      Dependabot::UpdateChecker.call(
        dependency: dependency,
        dependency_files: fetcher.files,
        allow: config[:allow],
        ignore: config[:ignore]
      )
    end
  end

  # Array of updated files
  #
  # @return [Array<Dependabot::DependencyFile>]
  def updated_files(updated_dependencies)
    Semaphore.synchronize do
      Dependabot::FileUpdater.call(
        dependencies: updated_dependencies,
        dependency_files: fetcher.files,
        package_manager: package_manager
      )
    end
  end

  # Create or update merge request
  #
  # @param [Hash] dep
  # @return [Gitlab::ObjectifiedHash]
  def create_mr(dep)
    Dependabot::MergeRequestService.call(
      project: project,
      fetcher: fetcher,
      updated_dependencies: dep[:dependencies],
      updated_files: updated_files(dep[:dependencies]),
      **config
    )
  end
end
