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
      # @param [Hash] config
      # @param [Dependabot::UpdatedDependency] updated_dependency
      # @param [Number] target_project_id
      def initialize(project:, fetcher:, config:, updated_dependency:, target_project_id:)
        @project = project
        @fetcher = fetcher
        @config = config
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
          close_superseeded_mrs
        end

        mr
      end

      private

      attr_reader :project,
                  :fetcher,
                  :updated_dependency,
                  :config,
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
          provider_metadata: { target_project_id: target_project_id },
          **mr_options
        ).send(:gitlab_creator)
      end

      # Persist merge request
      #
      # @return [void]
      def persist_mr # rubocop:disable Metrics/MethodLength
        ::MergeRequest.create!(
          project: project,
          id: mr.id,
          iid: mr.iid,
          package_ecosystem: config[:package_ecosystem],
          directory: config[:directory],
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

      # Close superseeded merge requests
      #
      # @return [void]
      def close_superseeded_mrs
        superseeded_mrs.each do |superseeded_mr|
          BranchRemover.call(project.name, superseeded_mr.branch)
          superseeded_mr.update_attributes!(state: "closed")
          next if target_project_id

          Commenter.call(
            project.name,
            superseeded_mr.iid,
            "This merge request has been superseeded by #{mr.web_url}"
          )
        end
        # close leftover mrs, primarily for forked projects without webhooks
        existing_mrs.each { |existing_mr| existing_mr.update_attributes!(state: "closed") }
      end

      # Get assignee ids
      #
      # @return [Array<Number>]
      def assignees
        @assignees ||= UserFinder.call(config[:assignees])
      end

      # Get reviewer ids
      #
      # @return [Array<Number>]
      def reviewers
        @reviewers ||= UserFinder.call(config[:reviewers])
      end

      # Get approver ids
      #
      # @return [Array<Number>]
      def approvers
        @approvers ||= UserFinder.call(config[:approvers])
      end

      def milestone_id
        @milestone_id ||= MilestoneFinder.call(fetcher.source.repo, config[:milestone])
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
          **config.select { |key, _value| MR_OPTIONS.include?(key) }
        }
      end

      # List of open superseeded merge requests
      #
      # @return [Mongoid::Criteria]
      def superseeded_mrs
        @superseeded_mrs ||= project.merge_requests
                                    .where(
                                      update_from: updated_dependency.previous_versions,
                                      state: "opened",
                                      directory: config[:directory]
                                    )
                                    .not(iid: mr.iid)
                                    .compact
      end

      # List of open existing mrs
      #
      # @return [Mongoid::Criteria]
      def existing_mrs
        @existing_mrs ||= project.merge_requests
                                 .where(main_dependency: updated_dependency.name, state: "opened")
                                 .not(iid: mr.iid)
                                 .compact
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
