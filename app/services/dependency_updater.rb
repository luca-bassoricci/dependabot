# frozen_string_literal: true

class DependencyUpdater < ApplicationService
  # @param [Hash<String, Object>] args
  def initialize(args)
    @repo, @package_manager = args.values_at("repo", "package_manager")
  end

  # Create or update mr's for dependencies
  #
  # @return [void]
  def call
    update_security_vulnerabilities
    update_dependencies
  end

  private

  attr_reader :repo, :package_manager

  # Dependabot config
  #
  # @return [Hash]
  def config
    @config ||= Dependabot::Config.call(repo)[package_manager]
  end

  # Get file fetcher
  #
  # @return [Dependabot::FileFetcher]
  def fetcher
    @fetcher ||= Dependabot::FileFetcher.call(
      package_manager: package_manager,
      source: Dependabot::DependabotSource.call(
        repo: repo,
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
    @dependencies ||= Dependabot::DependencyFetcher.call(
      source: fetcher.source,
      dependency_files: fetcher.files,
      package_manager: package_manager
    )
  end

  # Array of updated dependencies
  #
  # @return [Array<Dependabot::Dependency>]
  def updated_dependencies(dependency)
    Dependabot::UpdateChecker.call(
      dependency: dependency,
      dependency_files: fetcher.files,
      allow: config[:allow],
      ignore: config[:ignore]
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

  # Create or update merge request
  #
  # @param [Hash] dep
  # @return [Gitlab::ObjectifiedHash]
  def create_mr(dep)
    logger.info { "Updating #{dep[:name]}" }
    Dependabot::MergeRequestService.call(
      fetcher: fetcher,
      updated_dependencies: dep[:dependencies],
      updated_files: updated_files(dep[:dependencies]),
      **config
    )
  end
end
