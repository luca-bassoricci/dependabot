# frozen_string_literal: true

module Webhooks
  class MergeRequestEventHandler < ApplicationService
    # @param [String] project
    # @param [String] mr_iid
    def initialize(project_name:, mr_iid:, action:)
      @project_name = project_name
      @mr_iid = mr_iid
      @action = action
    end

    # Set merge request state to closed
    #
    # @return [void]
    def call
      log(:info, "Setting merge request !#{mr.iid} state to closed!")
      mr.update_attributes!(state: "closed")
      Gitlab::MergeRequest::Commenter.call(project_name, mr.iid, comment) if closed?
      return { closed_merge_request: true } if !merged? || config&.fetch(:rebase_strategy) == "none"

      triggered = trigger_update
      { update_triggered: triggered, closed_merge_request: true }
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    private

    attr_reader :project_name, :mr_iid, :action

    # Check if MR was merged
    #
    # @return [Boolean]
    def merged?
      action == "merge"
    end

    def closed?
      action == "close"
    end

    # Current project
    #
    # @return [Project]
    def project
      @project ||= Project.find_by(name: project_name)
    end

    # Merge request to close
    #
    # @return [<MergeRequest, nil>]
    def mr
      @mr ||= project.merge_requests.find_by(iid: mr_iid, state: "opened")
    end

    # Config entry for particular ecosystem and directory
    #
    # @return [Hash]
    def config
      @config ||= project.symbolized_config.find do |entry|
        entry[:package_ecosystem] == mr.package_ecosystem && entry[:directory] == mr.directory
      end
    end

    # Merge requests to update
    #
    # @return [Mongoid::Criteria]
    def updateable_mrs
      @updateable_mrs ||= project.merge_requests.where(
        state: "opened",
        package_ecosystem: mr.package_ecosystem,
        directory: mr.directory
      )
    end

    # Trigger dependency updates for same package_ecosystem mrs
    #
    # @return [void]
    def trigger_update
      return false if updateable_mrs.empty?

      log(:info, "Triggering open mr update for #{project_name}=>#{mr.package_ecosystem}=>#{mr.directory}")
      updateable_mrs.each do |merge_request|
        MergeRequestUpdateJob.perform_later(project_name, merge_request.iid)
      end

      true
    end

    # Closed mr message
    #
    # @return [String]
    def comment
      <<~TXT
        Dependabot won't notify anymore about this release, but will get in touch when a new version is available. \
        You can also ignore all major, minor, or patch releases for a dependency by adding an [`ignore` condition](https://docs.github.com/en/code-security/supply-chain-security/configuration-options-for-dependency-updates#ignore) with the desired `update_types` to your config file.
      TXT
    end
  end
end
