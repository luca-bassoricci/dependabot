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
    # @param [Dependabot::Dependency] dependency
    # @param [Hash] opts
    # @param [Array<Number>] assignees
    def initialize(fetcher:, dependency:, **opts)
      @fetcher = fetcher
      @dependency = dependency
      @options = opts
    end

    # Create merge request
    def call
      return unless updated_dependencies

      return update_mr if mr

      create_mr
    end

    private

    attr_reader :fetcher, :dependency, :options

    def create_mr
      mr = Dependabot::PullRequestCreator.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.call,
        **mr_opts
      ).create
      logger.info { "Created mr #{mr.web_url}" } if mr
    end

    def update_mr
      return logger.info { "Merge request #{mr.reference} doesn't require rebasing" } unless mr.has_conflicts

      logger.info { "Rebasing merge request #{mr.reference}" }
      Dependabot::PullRequestUpdater.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        old_commit: mr.sha,
        files: updated_files,
        credentials: Credentials.call,
        pull_request_number: mr.iid
      ).update
    end

    def source_branch
      @source_branch ||= Dependabot::PullRequestCreator::BranchNamer.new(
        dependencies: updated_dependencies,
        files: updated_files,
        target_branch: fetcher.source.branch,
        separator: mr_opts[:branch_name_separator],
        prefix: mr_opts[:branch_name_prefix]
      ).new_branch_name
    end

    def mr
      @mr ||= gitlab.merge_requests(
        fetcher.source.repo,
        source_branch: source_branch,
        target_branch: fetcher.source.branch,
        state: "opened",
        with_merge_status_recheck: true
      )&.first
    end

    def assignees
      return unless options[:assignees]

      Gitlab::UserFinder.call(options[:assignees])
    end

    def reviewers
      return unless options[:reviewers]

      Gitlab::UserFinder.call(options[:reviewers])
    end

    def mr_opts
      {
        assignees: assignees,
        reviewers: { approvers: reviewers },
        label_language: true,
        **options.select { |key, _value| MR_OPTIONS.include?(key) }
      }
    end

    # @return [Array<Dependabot::Dependency>]
    def updated_dependencies
      @updated_dependencies ||= Dependabot::UpdateChecker.call(
        dependency: dependency,
        dependency_files: fetcher.files
      )
    end

    # @return [Array<Dependabot::DependencyFile>]
    def updated_files
      @updated_files ||= Dependabot::FileUpdater.call(
        dependencies: updated_dependencies,
        dependency_files: fetcher.files
      )
    end
  end
end