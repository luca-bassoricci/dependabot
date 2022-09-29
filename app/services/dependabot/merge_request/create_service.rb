# frozen_string_literal: true

module Dependabot
  # :reek:InstanceVariableAssumption
  # :reek:RepeatedConditional
  # :reek:LongParameterList

  # rubocop:disable Metrics/ClassLength, Metrics/ParameterLists
  module MergeRequest
    class CreateService < ApplicationService
      using Rainbow

      # @param [Dependabot::Files::Fetchers::Base] fetcher
      # @param [Project] project
      # @param [Hash] config_entry
      # @param [Dependabot::Dependencies::UpdatedDependency] updated_dependency
      # @param [Array] credentials
      # @param [Boolean] recreate
      def initialize(fetcher:, project:, config_entry:, updated_dependency:, credentials:, recreate: false)
        @fetcher = fetcher
        @project = project
        @config_entry = config_entry
        @updated_dependency = updated_dependency
        @credentials = credentials
        @recreate = recreate
      end

      # Create or update MR
      #
      # @return [<Gitlab::ObjectifiedHash, nil>]
      def call
        if find_mr("closed")
          log(:warn, "  closed mr exists, skipping!")
          return
        end

        if DependabotConfig.dry_run?
          log(:info, "  dependabot is running in dry-run mode, skipping merge request creation!")
          return
        end

        # update existing mr if nothing was created
        update_mr unless create_mr

        accept_mr
        mr
      end

      private

      attr_reader :project,
                  :fetcher,
                  :updated_dependency,
                  :config_entry,
                  :credentials,
                  :recreate

      # Create mr and return true if created
      #
      # @return [Boolean]
      def create_mr
        # dependabot-core returns nil if branch && mr exists and nothing was created
        @mr = mr_creator.call || return

        log(:info, "  created merge request: #{mr.web_url.bright}")
      rescue Gitlab::Error::ResponseError => e
        # dependabot-core will try to create mr in the edge case when mr exists without the branch
        return if e.is_a?(Gitlab::Error::Conflict)
        # rescue in case mr is created but failed to add approvers/reviewers
        raise unless mr

        log_error(e)
        capture_error(e)
        true
      end

      # Update existing merge request
      #
      # @return [void]
      def update_mr
        return log(:info, " merge request #{mr.web_url.bright} doesn't require updating") unless update_mr?
        return rebase_mr unless recreate || mr["has_conflicts"]

        Dependabot::PullRequestUpdater.new(
          credentials: credentials,
          source: fetcher.source,
          base_commit: fetcher.commit,
          old_commit: mr_creator.commit_message,
          pull_request_number: mr.iid,
          files: updated_dependency.updated_files,
          provider_metadata: { target_project_id: target_project_id }
        ).update
        log(:info, "  recreated merge request #{mr.web_url.bright}")
      rescue Gitlab::Error::ResponseError => e
        log_error(e)
        capture_error(e)
      end

      # Rebase merge request
      #
      # @return [void]
      def rebase_mr
        gitlab.rebase_merge_request(target_project_id || project.name, mr.iid)
        log(:info, "  rebased merge request #{mr.web_url.bright}")
      end

      # Accept merge request and set to merge automatically
      #
      # @return [void]
      def accept_mr
        return unless AppConfig.standalone?
        return unless mr && updated_dependency.auto_mergeable?

        gitlab.accept_merge_request(
          mr.project_id,
          mr.iid,
          merge_when_pipeline_succeeds: true,
          squash: config_entry.dig(:auto_merge, :squash)
        )
        log(:info, "  accepted merge request")
      rescue Gitlab::Error::MethodNotAllowed, Gitlab::Error::NotAcceptable => e
        log(:error, " failed to accept merge request: #{e.message}")
      end

      # Target project id
      #
      # @return [Integer]
      def target_project_id
        return @target_project_id if defined?(@target_project_id)

        @target_project_id = config_entry[:fork] ? project.forked_from_id : nil
      end

      # Get existing mr
      #
      # @return [Gitlab::ObjectifiedHash]
      def mr
        @mr ||= find_mr("opened")
      end

      # MR creator service
      #
      # @return [Gitlab::MergeRequest::Creator]
      def mr_creator
        @mr_creator ||= Gitlab::MergeRequest::Creator.new(
          project: project,
          fetcher: fetcher,
          updated_dependency: updated_dependency,
          config_entry: config_entry,
          credentials: credentials,
          target_project_id: target_project_id
        )
      end

      # Automatically rebase MRs with conflicts only
      #
      # @return [Boolean]
      def rebase?
        config_entry.dig(:rebase_strategy, :strategy) == "auto"
      end

      # Automatically rebase all mr's
      #
      # @return [Boolean]
      def rebase_all?
        config_entry.dig(:rebase_strategy, :strategy) == "all"
      end

      # Check if mr should be updated
      #
      # @return [Boolean]
      def update_mr?
        recreate || rebase_all? || (rebase? && mr["has_conflicts"])
      end

      # Find existing mr
      #
      # @return [Gitlab::ObjectifiedHash]
      def find_mr(state)
        Gitlab::MergeRequest::Finder.call(
          project: target_project_id || fetcher.source.repo,
          source_branch: mr_creator.branch_name,
          target_branch: fetcher.source.branch,
          state: state
        )
      end
      # rubocop:enable Metrics/ClassLength, Metrics/ParameterLists
    end
  end
end
