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

      return { closed_merge_request: true } unless merged?

      log(:info, "Triggering open mr update for #{project_name}=>#{mr.package_ecosystem}=>#{mr.directory}")
      trigger_update
      { update_triggered: true, closed_merge_request: true }
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

    # Merge requests to update
    #
    # @return [Array<MergeRequest>]
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
      # TODO: remove in a few releases
      return unless mr.package_ecosystem

      updateable_mrs.each do |merge_request|
        MergeRequestUpdateJob.perform_later(project_name, merge_request.iid)
      end
    end
  end
end
