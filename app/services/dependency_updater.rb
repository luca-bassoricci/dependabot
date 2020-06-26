# frozen_string_literal: true

class DependencyUpdater < ApplicationService
  def initialize(args)
    @repo, @package_manager = args.values_at("repo", "package_manager")
  end

  def call
    dependencies.each do |dependency|
      DependabotServices::MergeRequestCreator.call(
        fetcher: fetcher,
        dependency: dependency,
        **config
      )
    end
  end

  private

  attr_reader :repo, :package_manager

  def config
    @config ||= Configuration::Parser.call(Gitlab::ConfigFetcher.call(repo))[package_manager]
  end

  def fetcher
    @fetcher ||= DependabotServices::FileFetcher.call(
      package_manager: package_manager,
      source: DependabotServices::DependabotSource.call(
        repo: repo,
        branch: config[:branch],
        directory: config[:directory]
      )
    )
  end

  def dependencies
    @dependencies ||= DependabotServices::DependencyFetcher.call(
      source: fetcher.source,
      dependency_files: fetcher.files,
      package_manager: package_manager
    )
  end
end
