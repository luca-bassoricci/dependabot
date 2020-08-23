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
    dependencies.each do |dependency|
      Dependabot::MergeRequestService.call(
        fetcher: fetcher,
        dependency: dependency,
        **config
      )
    end
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

  # Get dependencies
  #
  # @return [Array<Dependabot::Dependency>]
  def dependencies
    @dependencies ||= Dependabot::DependencyFetcher.call(
      source: fetcher.source,
      dependency_files: fetcher.files,
      package_manager: package_manager,
      allow: config[:allow],
      ignore: config[:ignore]
    )
  end
end
