# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Creator < ApplicationService
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
          pr_message_footer: AppConfig.standalone ? nil : message_footer,
          **mr_options
        ).create.tap { |mr| log(:info, "created mr #{mr.web_url}") if mr }
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
          reviewers: reviewers ? { approvers: reviewers } : {},
          **config.select { |key, _value| MR_OPTIONS.include?(key) }
        }
      end

      # MR message footer with available commands
      #
      # @return [String]
      def message_footer
        <<~MSG
          ---

          <details>
          <summary>Dependabot commands</summary>
          <br />
          You can trigger Dependabot actions by commenting on this MR

          - `$dependabot rebase` will rebase this MR
          - `$dependabot recreate` will recreate this MR rewriting all the manual changes and resolving conflicts

          </details>
        MSG
      end
    end
  end
end