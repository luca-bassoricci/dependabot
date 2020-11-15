# frozen_string_literal: true

require "dependabot/pull_request_updater"

module Dependabot
  class MergeRequestService < ApplicationService
    MR_OPTIONS = %i[
      custom_labels
      commit_message_options
      branch_name_separator
      branch_name_prefix
      milestone
    ].freeze

    # @param [String] name Updated dependency name for logging
    # @param [Dependabot::FileFetchers::Base] fetcher
    # @param [Array<Dependabot::Dependency>] updated_dependencies
    # @param [Array<Dependabot::DependencyFile>] updated_files
    # @param [Hash] opts
    def initialize(fetcher:, updated_dependencies:, updated_files:, project:, **opts)
      @fetcher = fetcher
      @updated_dependencies = updated_dependencies
      @updated_files = updated_files
      @project = project
      @options = opts
    end

    # Create or update MR
    #
    # @return [void]
    def call
      logger.info { "Updating following dependencies: #{dependencies_for_update}" }
      mr ? update_mr : create_mr
      accept_mr

      mr
    end

    private

    attr_reader :project, :fetcher, :updated_dependencies, :updated_files, :options

    # Create mr
    #
    # @return [void]
    def create_mr
      @mr = Gitlab::MergeRequestCreator.call(
        fetcher: fetcher,
        updated_dependencies: updated_dependencies,
        updated_files: updated_files,
        mr_options: mr_opts
      )
      save unless Settings.standalone
    end

    # Persist merge request
    #
    # @return [void]
    def save
      return unless mr

      MergeRequest.create!(
        project: project,
        iid: mr.iid,
        package_manager: options[:package_manager],
        state: "opened",
        auto_merge: options[:auto_merge],
        dependencies: updated_dependencies.map { |dep| "#{dep.name}-#{dep.previous_version}" }.join("/")
      )
    end

    # Rebase existing mr if it has conflicts
    #
    # @return [void]
    def update_mr
      return unless rebase?

      Gitlab::MergeRequestUpdater.call(
        fetcher: fetcher,
        updated_files: updated_files,
        merge_request: mr
      )
    end

    # Accept merge request and set to merge automatically
    #
    # @return [void]
    def accept_mr
      return unless mr && options[:auto_merge]

      Gitlab::MergeRequestAcceptor.call(mr)
    end

    # Get source branch name
    #
    # @return [String]
    def source_branch
      @source_branch ||= Dependabot::PullRequestCreator::BranchNamer.new(
        dependencies: updated_dependencies,
        files: updated_files,
        target_branch: fetcher.source.branch,
        separator: mr_opts[:branch_name_separator],
        prefix: mr_opts[:branch_name_prefix]
      ).new_branch_name
    end

    # Get existing mr
    #
    # @return [Gitlab::ObjectifiedHash] if mr exists
    #
    # @return [nil] if merge request doesn't exist
    def mr
      @mr ||= Gitlab::MergeRequestFinder.call(
        project: fetcher.source.repo,
        source_branch: source_branch,
        target_branch: fetcher.source.branch,
        state: "opened"
      )
    end

    # Get assignee ids
    #
    # @return [Array<Number>]
    def assignees
      @assignees ||= begin
        return unless options[:assignees]

        Gitlab::UserFinder.call(options[:assignees])
      end
    end

    # Get reviewer ids
    #
    # @return [Array<Number>]
    def reviewers
      @reviewers ||= begin
        return unless options[:reviewers]

        Gitlab::UserFinder.call(options[:reviewers])
      end
    end

    # Merge request options
    #
    # @return [Hash]
    def mr_opts
      @mr_opts ||= {
        assignees: assignees,
        reviewers: { approvers: reviewers },
        label_language: true,
        **options.select { |key, _value| MR_OPTIONS.include?(key) }
      }
    end

    # Automatically rebase MR
    #
    # @return [Boolean]
    def rebase?
      options[:rebase_strategy] == "auto"
    end

    # All dependencies to be updated
    #
    # @return [String]
    def dependencies_for_update
      updated_dependencies.map { |dep| "#{dep.name}-#{dep.version}" }.join("/")
    end
  end
end
