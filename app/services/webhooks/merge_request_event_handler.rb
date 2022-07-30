# frozen_string_literal: true

module Webhooks
  class MergeRequestEventHandler < HookHandler
    # @param [String] project
    # @param [String] mr_iid
    def initialize(project_name:, mr_iid:, action:, merge_status:)
      super(project_name)

      @mr_iid = mr_iid
      @action = action
      @merge_status = merge_status
    end

    # Set merge request state to closed
    #
    # @return [void]
    def call
      return reopen_mr if reopened?
      return close_mr if closed?
      return update_mrs if merged?
      return update_mr if approved?
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    private

    attr_reader :mr_iid, :action, :merge_status

    # Reopen closed merge request
    #
    # @return [Hash]
    def reopen_mr
      log(:info, "Reopening merge request !#{mr(state: 'closed').iid} for project #{project_name}!")

      mr.update_attributes!(state: "opened")
      recreated = recreate_branch
      MergeRequestUpdateJob.perform_later(
        project_name,
        mr_iid,
        recreated ? Dependabot::MergeRequest::UpdateService::RECREATE : Dependabot::MergeRequest::UpdateService::UPDATE
      )

      { reopened_merge_request: true }
    end

    # Close merge request
    #
    # @return [Hash]
    def close_mr
      log(:info, "Setting merge request !#{mr.iid} state to closed for project #{project_name}!")

      mr.close

      Gitlab::BranchRemover.call(project_name, mr.branch)
      Gitlab::MergeRequest::Commenter.call(project_name, mr.iid, ignore_comment)

      { closed_merge_request: true }
    end

    # Update open mrs of same package ecosystem
    #
    # @return [Hash]
    def update_mrs
      log(:info, "Setting merge request !#{mr.iid} state to merged for project #{project_name}!")
      mr.update_attributes!(state: "merged")

      {
        update_triggered: config.dig(:rebase_strategy, :strategy) == "none" ? false : trigger_update,
        closed_merge_request: true
      }
    end

    # Update single mr
    #
    # @return [Hash]
    def update_mr
      return unless config.dig(:rebase_strategy, :on_approval)

      log(:info, "Triggering rebase for !#{mr.iid} for project #{project_name}!")
      gitlab.rebase_merge_request(project_name, mr_iid)

      { merge_request_rebase_triggered: true }
    end

    # Check if reopen event action
    #
    # @return [Boolean]
    def reopened?
      action == "reopen"
    end

    # Check if merge event action
    #
    # @return [Boolean]
    def merged?
      action == "merge"
    end

    # Check if close event action
    #
    # @return [Boolean]
    def closed?
      action == "close"
    end

    def approved?
      action == "approved"
    end

    # Merge request to close
    #
    #
    # @param [String] state
    # @return [MergeRequest]
    def mr(state: "opened")
      @mr ||= project.merge_requests.find_by(iid: mr_iid, state: state)
    end

    # Config entry for particular ecosystem and directory
    #
    # @return [Hash]
    def config
      @config ||= project.configuration.entry(package_ecosystem: mr.package_ecosystem, directory: mr.directory)
    end

    # Merge requests to update
    #
    # @return [Array<MergeRequest>]
    def updateable_mrs
      @updateable_mrs ||= project.open_merge_requests(package_ecosystem: mr.package_ecosystem, directory: mr.directory)
    end

    # Trigger dependency updates for same package_ecosystem mrs
    #
    # @return [void]
    def trigger_update
      return false if updateable_mrs.empty?

      log(:info, "Triggering open mr update for #{project_name}=>#{mr.package_ecosystem}=>#{mr.directory}")
      updateable_mrs.each do |merge_request|
        MergeRequestUpdateJob.perform_later(
          project_name,
          merge_request.iid,
          Dependabot::MergeRequest::UpdateService::AUTO_REBASE
        )
      end

      true
    end

    # Recreate mr branch if it doesn't exist
    #
    # @return [Boolean]
    def recreate_branch
      gitlab.branch(project_name, mr.branch) && false
    rescue Gitlab::Error::NotFound
      gitlab.create_branch(project_name, mr.branch, mr.target_branch) && true
    end

    # Closed mr message
    #
    # @return [String]
    def ignore_comment
      <<~TXT
        Dependabot won't notify anymore about this release, but will get in touch when a new version is available. \
        You can also ignore all major, minor, or patch releases for a dependency by adding an [`ignore` condition](https://docs.github.com/en/code-security/supply-chain-security/configuration-options-for-dependency-updates#ignore) with the desired `update_types` to your config file.
      TXT
    end
  end
end
