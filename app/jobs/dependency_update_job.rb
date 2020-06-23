# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  # Perform dependency updates and merge request creation
  # @param [Hash] params
  # @option params [Number] :repo
  # @option params [String] :package_manager
  # @option params [String] :directory
  # @option params [Array<String>] :allowed_dependencies
  # @option params [Array<String>] :allowed_dependency_types
  # @option params [Array<String>] :ignored_dependencies
  # @option params [Array<String>] :ignored_dependency_types
  # @option params [Number] :open_merge_requests
  # @option params [String] :branch_name_separator
  # @option params [String] :target_branch
  # @return [void]
  def perform(repo:, package_manager:, **opts)
    source = DependabotServices::DependabotSource.call(repo: repo)
    fetcher = DependabotServices::FileFetcher.call(source: source, package_manager: package_manager)

    DependabotServices::DependencyFetcher.call(
      source: source,
      dependency_files: fetcher.files,
      package_manager: package_manager, **opts
    ).each do |dependency|
      DependabotServices::MergeRequestCreator.call(
        source: source,
        fetcher: fetcher,
        dependency: dependency,
        assignees: opts[:assignees]
      )
    end
  end
end
