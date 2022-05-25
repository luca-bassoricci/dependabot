# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Creator < ApplicationService # rubocop:disable Metrics/ClassLength
      MR_OPTIONS = %i[
        custom_labels
        commit_message_options
        branch_name_separator
        branch_name_prefix
      ].freeze

      delegate :commit_message, :branch_name, to: :gitlab_creator

      # @param [Project] project
      # @param [Dependabot::Files::Fetchers::Base] fetcher
      # @param [Hash] config_entry
      # @param [Dependabot::UpdatedDependency] updated_dependency
      # @param [Number] target_project_id
      def initialize(project:, fetcher:, config_entry:, updated_dependency:, target_project_id:)
        @project = project
        @fetcher = fetcher
        @config_entry = config_entry
        @updated_dependency = updated_dependency
        @target_project_id = target_project_id
      end

      # Create merge request
      #
      # @return [Gitlab::ObjectifiedHash]
      def call
        @mr = gitlab_creator.create

        if mr && !AppConfig.standalone?
          persist_mr
          close_superseded_mrs
        end

        mr
      end

      private

      attr_reader :project,
                  :fetcher,
                  :updated_dependency,
                  :config_entry,
                  :target_project_id,
                  :mr

      # Gitlab merge request creator
      #
      # @return [Dependabot::PullRequestCreator::Gitlab]
      def gitlab_creator
        @gitlab_creator ||= Dependabot::PullRequestCreator.new(
          source: fetcher.source,
          base_commit: fetcher.commit,
          dependencies: updated_dependency.updated_dependencies,
          files: updated_dependency.updated_files,
          credentials: Dependabot::Credentials.call,
          github_redirection_service: "github.com",
          pr_message_footer: AppConfig.standalone ? nil : message_footer,
          automerge_candidate: updated_dependency.auto_mergeable?,
          vulnerabilities_fixed: updated_dependency.fixed_vulnerabilities,
          provider_metadata: { target_project_id: target_project_id },
          **mr_options
        ).send(:gitlab_creator)
      end

      # Persist merge request
      #
      # @return [void]
      def persist_mr
        ::MergeRequest.create!(
          project: project,
          id: mr.id,
          iid: mr.iid,
          package_ecosystem: config_entry[:package_ecosystem],
          directory: config_entry[:directory],
          state: "opened",
          auto_merge: updated_dependency.auto_mergeable?,
          update_from: updated_dependency.previous_versions,
          update_to: updated_dependency.current_versions,
          main_dependency: updated_dependency.name,
          branch: gitlab_creator.branch_name,
          target_branch: fetcher.source.branch,
          commit_message: gitlab_creator.commit_message,
          target_project_id: target_project_id
        )
      end

      # Close superseded merge requests
      #
      # @return [void]
      def close_superseded_mrs
        superseded_mrs.each do |superseded_mr|
          superseded_mr.close
          BranchRemover.call(project.name, superseded_mr.branch)
          Commenter.call(
            target_project_id || project.name,
            superseded_mr.iid,
            "This merge request has been superseded by #{mr.web_url}"
          )
        end
      end

      # Get assignee ids
      #
      # @return [Array<Number>]
      def assignees
        @assignees ||= UserFinder.call(config_entry[:assignees])
      end

      # Get reviewer ids
      #
      # @return [Array<Number>]
      def reviewers
        @reviewers ||= UserFinder.call(config_entry[:reviewers])
      end

      # Get approver ids
      #
      # @return [Array<Number>]
      def approvers
        @approvers ||= UserFinder.call(config_entry[:approvers])
      end

      def milestone_id
        @milestone_id ||= MilestoneFinder.call(fetcher.source.repo, config_entry[:milestone])
      end

      # Merge request specific options from config
      #
      # @return [Hash]
      def mr_options
        @mr_options ||= {
          label_language: true,
          assignees: assignees,
          reviewers: { approvers: approvers, reviewers: reviewers }.compact,
          milestone: milestone_id,
          **config_entry.select { |key, _value| MR_OPTIONS.include?(key) }
        }
      end

      # List of open superseded merge requests
      #
      # @return [Mongoid::Criteria]
      def superseded_mrs
        @superseded_mrs ||= project.superseded_mrs(
          update_from: updated_dependency.previous_versions,
          directory: config_entry[:directory],
          mr_iid: mr.iid
        )
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

          - `#{AppConfig.commands_prefix} rebase` will rebase this MR
          - `#{AppConfig.commands_prefix} recreate` will recreate this MR rewriting all the manual changes and resolving conflicts

          </details>
        MSG
      end
    end
  end
end
