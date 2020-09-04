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

    # @param [Dependabot::FileFetchers::Base] fetcher
    # @param [Array<Dependabot::Dependency>] updated_dependencies
    # @param [Array<Dependabot::DependencyFile>] updated_files
    # @param [Hash] opts
    def initialize(fetcher:, updated_dependencies:, updated_files:, **opts)
      @fetcher = fetcher
      @updated_dependencies = updated_dependencies
      @updated_files = updated_files
      @options = opts
    end

    # Create or update MR
    #
    # @return [void]
    def call
      return update_mr if rebase? && mr

      create_mr
    end

    private

    attr_reader :fetcher, :updated_dependencies, :updated_files, :options

    # Create mr
    #
    # @return [void]
    def create_mr
      mr = Dependabot::PullRequestCreator.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.fetch,
        **mr_opts
      ).create

      logger.info { "Created mr #{mr.web_url}" } if mr
      mr
    rescue Octokit::TooManyRequests
      logger.error { "Github API rate limit exceeded! See: https://developer.github.com/v3/#rate-limiting" }
    end

    # Rebase existing mr if it has conflicts
    #
    # @return [void]
    def update_mr
      return logger.info { "Merge request #{mr.reference} doesn't require rebasing" } unless mr.has_conflicts

      logger.info { "Rebasing merge request #{mr.reference}" }
      Dependabot::PullRequestUpdater.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        old_commit: mr.sha,
        files: updated_files,
        credentials: Credentials.fetch,
        pull_request_number: mr.iid
      ).update
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
      @mr ||= gitlab.merge_requests(
        fetcher.source.repo,
        source_branch: source_branch,
        target_branch: fetcher.source.branch,
        state: "opened",
        with_merge_status_recheck: true
      )&.first
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

    # MR options
    #
    # @return [Hash]
    def mr_opts
      {
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
  end
end
