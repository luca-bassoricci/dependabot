# frozen_string_literal: true

module Dependabot
  module MergeRequest
    # :reek:TooManyConstants
    class UpdateService < UpdateBase
      RECREATE = "recreate"
      UPDATE = "update"
      AUTO_REBASE = "auto_rebase"

      RECREATED = "recreated"
      REBASED = "rebased"
      SKIPPED = "skipped"
      CLOSED = "closed"

      def initialize(project_name:, mr_iid:, action:)
        super(project_name)

        @mr_iid = mr_iid
        @action = action
      end

      # Trigger merge request update
      #
      # @return [void]
      def call
        log(:info, "Running update for merge request !#{mr_iid}")
        init_gitlab

        return skip_mr unless recreate? || updateable? # skip updateable check for explicit recreate
        return rebase_mr unless recreate? || gitlab_mr["has_conflicts"]

        (Semaphore.synchronize { update }).tap { |status| log_result(status) }
      ensure
        FileUtils.rm_r(repo_contents_path, force: true, secure: true) if repo_contents_path
      end

      private

      delegate :package_ecosystem, :directory, to: :mr

      attr_reader :project_name, :mr_iid, :action

      # Main dependency name
      #
      # @return [String]
      def dependency_name
        mr.main_dependency
      end

      # Performing recreate action
      #
      # @return [Boolean] <description>
      def recreate?
        action == "recreate"
      end

      # Performing auto-rebase after other merge request merged
      #
      # @return [Boolean]
      def auto_rebase?
        action == "auto_rebase"
      end

      # Is mr updateable
      # * mr in open state
      # * mr has correct assignee when configured and auto-rebase action performed
      #
      # @return [Boolean]
      def updateable?
        gitlab_mr.state == "opened" && (!auto_rebase? || !rebase_assignee || rebase_assignee == mr_assignee)
      end

      # Log mr update skipped
      #
      # @return [void]
      def skip_mr
        msg = if gitlab_mr.state != "opened"
                "Merge request is not in opened state!"
              else
                "Merge request assignee doesn't match configured one!"
              end

        log_result(SKIPPED, msg)
      end

      # Rebase merge request
      #
      # @return [void]
      def rebase_mr
        gitlab.rebase_merge_request(project_name, mr_iid)
        log_result(REBASED)
      end

      # Recreate merge request
      #
      # @return [void]
      def update
        raise("Dependency '#{dependency_name}' not found in manifest file!") unless updated_dep
        return close_mr if updated_dep.up_to_date?

        raise("Dependency update is impossible!") if updated_dep.update_impossible?
        raise("Newer version for update exists, new merge request will be created!") unless same_version?

        Dependabot::PullRequestUpdater.new(
          credentials: credentials,
          source: fetcher.source,
          base_commit: fetcher.commit,
          old_commit: mr.commit_message,
          pull_request_number: mr.iid,
          files: updated_dep.updated_files,
          provider_metadata: { target_project_id: mr.target_project_id }
        ).update

        RECREATED
      end

      # Updated dependency
      #
      # @return [Dependabot::Dependencies::UpdatedDependency]
      def updated_dep
        @updated_dep ||= updated_dependency(dependencies.first)
      end

      # Close obsolete merge request
      #
      # @return [void]
      def close_mr
        Gitlab::BranchRemover.call(project_name, mr.branch) && mr.close
        CLOSED
      end

      # Auto-rebase assignee option
      #
      # @return [Boolean]
      def rebase_assignee
        @rebase_assignee ||= config_entry.dig(:rebase_strategy, :with_assignee)
      end

      # Merge request assignee
      #
      # @return [String]
      def mr_assignee
        @mr_assignee ||= gitlab_mr.to_h.dig("assignee", "username")
      end

      # Find merge request
      #
      # @return [MergeRequest]
      def mr
        @mr ||= project.merge_requests.find_by(iid: mr_iid)
      end

      # Project
      #
      # @return [Project]
      def project
        @project ||= super
      end

      # Gitlab merge request
      #
      # @return [Gitlab::ObjectifiedHash]
      def gitlab_mr
        @gitlab_mr ||= gitlab.merge_request(project_name, mr_iid)
      end

      # Check if newer version exist
      #
      # @return [Boolean]
      def same_version?
        mr.update_to == updated_dep.current_versions
      end

      # Log update result
      #
      # @param [String] status
      # @param [String] details
      # @return [void]
      def log_result(status, details = "")
        log(:info, "  #{status} merge request #{gitlab_mr.web_url}! #{details}".strip)

        status
      end
    end
  end
end
