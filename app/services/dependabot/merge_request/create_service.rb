# frozen_string_literal: true

module Dependabot
  # :reek:InstanceVariableAssumption
  # :reek:RepeatedConditional
  module MergeRequest
    class CreateService < ApplicationService
      using Rainbow

      # @param [Dependabot::Files::Fetchers::Base] fetcher
      # @param [Project] project
      # @param [Hash] config
      # @param [Dependabot::UpdatedDependency] updated_dependency
      def initialize(fetcher:, project:, config:, updated_dependency:, recreate: false)
        @fetcher = fetcher
        @project = project
        @config = config
        @updated_dependency = updated_dependency
        @recreate = recreate
      end

      # Create or update MR
      #
      # @return [void]
      def call
        if find_mr("closed")
          log(:warn, "  closed mr exists, skipping!")
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
                  :config,
                  :recreate

      # Create mr
      #
      # @return [void]
      def create_mr
        @mr = mr_creator.call || return # dependabot-core returns nil if branch && mr exists and nothing was created

        log(:info, "  created merge request: #{mr.web_url.bright}")
        mr
      rescue Gitlab::Error::ResponseError => e
        # dependabot-core will try to create mr in the edge case when mr exists without the branch
        return if e.is_a?(Gitlab::Error::Conflict)
        # rescue in case mr is created but failed to add approvers/reviewers
        raise unless mr

        log_error(e)
        capture_error(e)
        mr
      end

      # Update existing merge request
      #
      # @return [void]
      def update_mr
        return log(:info, " merge request #{mr.web_url.bright} doesn't require updating") unless update_mr?
        return rebase_mr unless recreate || mr["has_conflicts"] || target_project_id

        Dependabot::PullRequestUpdater.new(
          credentials: Dependabot::Credentials.call,
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
        mr
      end

      # Rebase merge request
      #
      # @return [void]
      def rebase_mr
        gitlab.rebase_merge_request(project.name, mr.iid)
        log(:info, "  rebased merge request #{mr.web_url.bright}")
      end

      # Accept merge request and set to merge automatically
      #
      # @return [void]
      def accept_mr
        return unless AppConfig.standalone?
        return unless mr && updated_dependency.auto_mergeable?

        gitlab.accept_merge_request(mr.project_id, mr.iid, merge_when_pipeline_succeeds: true)
        log(:info, "  accepted merge request")
      rescue Gitlab::Error::MethodNotAllowed, Gitlab::Error::NotAcceptable => e
        log(:error, " failed to accept merge request: #{e.message}")
      end

      # Target project id
      #
      # @return [Integer]
      def target_project_id
        return @target_project_id if defined?(@target_project_id)

        @target_project_id = config[:fork] ? project.forked_from_id : nil
      end

      # Get existing mr
      #
      # @return [Gitlab::ObjectifiedHash]
      def mr
        @mr ||= find_mr("opened")
      end

      # Automatically rebase MRs with conflicts only
      #
      # @return [Boolean]
      def rebase?
        config.dig(:rebase_strategy, :strategy) == "auto"
      end

      # Automatically rebase all mr's
      #
      # @return [Boolean]
      def rebase_all?
        config.dig(:rebase_strategy, :strategy) == "all"
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

      # MR creator service
      #
      # @return [Dependabot::PullRequestCreator::Gitlab]
      def mr_creator
        @mr_creator ||= Gitlab::MergeRequest::Creator.new(
          project: project,
          fetcher: fetcher,
          updated_dependency: updated_dependency,
          config: config,
          target_project_id: target_project_id
        )
      end
    end
  end
end
