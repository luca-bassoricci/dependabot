# frozen_string_literal: true

module Dependabot
  # :reek:TooManyInstanceVariables
  # :reek:InstanceVariableAssumption
  # :reek:RepeatedConditional
  module MergeRequest
    class CreateService < ApplicationService # rubocop:disable Metrics/ClassLength
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
        log(:info, "Updating following dependencies: #{current_versions}")
        if find_mr("closed")
          log(:warn, " closed mr exists, skipping!")
          return
        end

        if create_mr
          persist_mr
          close_superseeded_mrs
        else
          update_mr
        end

        accept_mr
        mr
      end

      private

      delegate :updated_files, :updated_dependencies, :name, :previous_versions, :current_versions,
               to: :updated_dependency

      attr_reader :project, :fetcher, :updated_dependency, :config, :recreate

      # Create mr
      #
      # @return [void]
      def create_mr
        @mr = Gitlab::MergeRequest::Creator.call(
          fetcher: fetcher,
          updated_dependencies: updated_dependencies,
          updated_files: updated_files,
          config: config,
          target_project_id: target_project_id
        ) || return # dependabot-core returns nil if branch && mr exists and nothing was created

        log(:info, "  created merge request: #{mr.web_url}")
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

      # Persist merge request
      #
      # @return [void]
      def persist_mr
        return if AppConfig.standalone

        ::MergeRequest.create!(
          project: project,
          id: mr.id,
          iid: mr.iid,
          package_ecosystem: config[:package_ecosystem],
          directory: config[:directory],
          state: "opened",
          auto_merge: updated_dependency.auto_mergeable?,
          dependencies: previous_versions,
          main_dependency: name,
          branch: source_branch,
          target_project_id: target_project_id
        )
      end

      # Close superseeded merge requests
      #
      # @return [void]
      def close_superseeded_mrs
        return if AppConfig.standalone

        superseeded_mrs.each do |superseeded_mr|
          Gitlab::BranchRemover.call(project.name, superseeded_mr.branch)
          superseeded_mr.update_attributes!(state: "closed")
          next if target_project_id

          Gitlab::MergeRequest::Commenter.call(
            project.name,
            superseeded_mr.iid,
            "This merge request has been superseeded by #{mr.web_url}"
          )
        end
        # close leftover mrs, primarily for forked projects without webhooks
        existing_mrs.each { |existing_mr| existing_mr.update_attributes!(state: "closed") }
      end

      # Update existing merge request
      #
      # @return [void]
      def update_mr
        return log(:info, " merge request #{mr.web_url} doesn't require updating") unless update_mr?

        Gitlab::MergeRequest::Updater.call(
          fetcher: fetcher,
          updated_files: updated_files,
          merge_request: mr,
          target_project_id: target_project_id,
          recreate: recreate
        )
      end

      # Accept merge request and set to merge automatically
      #
      # @return [void]
      def accept_mr
        return unless AppConfig.standalone
        return unless mr && updated_dependency.auto_mergeable?

        gitlab.accept_merge_request(mr.project_id, mr.iid, merge_when_pipeline_succeeds: true)
        log(:info, "  accepted merge request")
      rescue Gitlab::Error::MethodNotAllowed, Gitlab::Error::NotAcceptable => e
        log(:error, " failed to accept merge request: #{e.message}")
      end

      # Get source branch name
      #
      # @return [String]
      def source_branch
        @source_branch ||= Dependabot::PullRequestCreator::BranchNamer.new(
          dependencies: updated_dependencies,
          files: updated_files,
          target_branch: fetcher.source.branch,
          separator: config[:branch_name_separator],
          prefix: config[:branch_name_prefix]
        ).new_branch_name
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
        config[:rebase_strategy] == "auto"
      end

      # Automatically rebase all mr's
      #
      # @return [Boolean]
      def rebase_all?
        config[:rebase_strategy] == "all"
      end

      # Check if mr should be updated
      #
      # @return [Boolean]
      def update_mr?
        recreate || rebase_all? || (rebase? && mr.has_conflicts)
      end

      # List of open superseeded merge requests
      #
      # @return [Mongoid::Criteria]
      def superseeded_mrs
        @superseeded_mrs ||= project.merge_requests
                                    .where(
                                      dependencies: previous_versions,
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
                                 .where(main_dependency: name, state: "opened")
                                 .not(iid: mr.iid)
                                 .compact
      end

      # Find existing mr
      #
      # @return [Gitlab::ObjectifiedHash]
      def find_mr(state)
        Gitlab::MergeRequest::Finder.call(
          project: target_project_id || fetcher.source.repo,
          source_branch: source_branch,
          target_branch: fetcher.source.branch,
          state: state
        )
      end
    end
  end
end
