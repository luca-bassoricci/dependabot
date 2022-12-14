# frozen_string_literal: true

module Gitlab
  module MergeRequest
    # :reek:LongParameterList
    # rubocop:disable Metrics/ClassLength, Metrics/ParameterLists

    class Creator < ApplicationService
      MR_OPTIONS = %i[
        custom_labels
        branch_name_separator
        branch_name_prefix
      ].freeze

      # @param [Project] project
      # @param [Dependabot::Files::Fetchers::Base] fetcher
      # @param [Hash] config_entry
      # @param [Dependabot::UpdatedDependency] updated_dependency
      # @param [Number] target_project_id
      def initialize(project:, fetcher:, config_entry:, updated_dependency:, credentials:, target_project_id:)
        @project = project
        @fetcher = fetcher
        @config_entry = config_entry
        @updated_dependency = updated_dependency
        @credentials = credentials
        @target_project_id = target_project_id
      end

      delegate :commit_message, :branch_name, to: :gitlab_creator

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

      delegate :vulnerable?, :production?, to: :updated_dependency

      attr_reader :project,
                  :fetcher,
                  :updated_dependency,
                  :config_entry,
                  :credentials,
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
          credentials: credentials,
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
          squash: squash?,
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
        UserFinder.call(config_entry[:assignees])
      end

      # Get reviewer ids
      #
      # @return [Array<Number>]
      def reviewers
        UserFinder.call(config_entry[:reviewers])
      end

      # Get approver ids
      #
      # @return [Array<Number>]
      def approvers
        UserFinder.call(config_entry[:approvers])
      end

      # Milestone id
      #
      # @return [Integer]
      def milestone_id
        MilestoneFinder.call(project, config_entry[:milestone])
      end

      # Merge request specific options from config
      #
      # @return [Hash]
      def mr_options
        {
          label_language: true,
          assignees: assignees,
          reviewers: { approvers: approvers, reviewers: reviewers }.compact,
          milestone: milestone_id,
          commit_message_options: commit_message_options,
          **config_entry.slice(*MR_OPTIONS)
        }
      end

      # Commit message options
      #
      # @return [Hash]
      def commit_message_options
        opts = config_entry[:commit_message_options]

        return {} unless opts

        trailers_security = opts.delete(:trailers_security)
        trailers_development = opts.delete(:trailers_development)
        return opts.merge({ trailers: trailers_security }) if vulnerable? && trailers_security
        return opts.merge({ trailers: trailers_development }) if !production? && trailers_development

        opts
      end

      # List of open superseded merge requests
      #
      # @return [Mongoid::Criteria]
      def superseded_mrs
        project.superseded_mrs(
          update_from: updated_dependency.previous_versions,
          package_ecosystem: config_entry[:package_ecosystem],
          directory: config_entry[:directory],
          mr_iid: mr.iid
        )
      end

      # Squash merge request on auto-merge
      #
      # @return [Boolean]
      def squash?
        return false unless updated_dependency.auto_mergeable?

        config_entry.dig(:auto_merge, :squash).nil? ? false : true
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
  # rubocop:enable Metrics/ClassLength, Metrics/ParameterLists
end
