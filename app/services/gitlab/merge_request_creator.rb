# frozen_string_literal: true

module Gitlab
  class MergeRequestCreator < ApplicationService
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
    # @param [Hash] mr_options
    def initialize(fetcher:, updated_dependencies:, updated_files:, config:)
      @fetcher = fetcher
      @updated_dependencies = updated_dependencies
      @updated_files = updated_files
      @config = config
    end

    # Create merge request
    #
    # @return [Gitlab::ObjectifiedHash]
    def call
      Dependabot::PullRequestCreator.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.fetch,
        github_redirection_service: "github.com",
        **mr_options
      ).create.tap { |mr| logger.info { "created mr #{mr.web_url}" } if mr }
    end

    private

    attr_reader :fetcher, :updated_dependencies, :updated_files, :config

    # Get assignee ids
    #
    # @return [Array<Number>]
    def assignees
      @assignees ||= Gitlab::UserFinder.call(config[:assignees])
    end

    # Get reviewer ids
    #
    # @return [Array<Number>]
    def reviewers
      @reviewers ||= Gitlab::UserFinder.call(config[:reviewers])
    end

    # Merge request specific options from config
    #
    # @return [Hash]
    def mr_options
      @mr_options ||= {
        label_language: true,
        assignees: assignees,
        reviewers: { approvers: reviewers },
        **config.select { |key, _value| MR_OPTIONS.include?(key) }
      }
    end
  end
end
