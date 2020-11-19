# frozen_string_literal: true

module Webhooks
  class MergeRequestEventHandler < ApplicationService
    # @param [ActionController::Parameters] params
    def initialize(project, mr_iid)
      @project = project
      @mr_iid = mr_iid
    end

    # Set merge request state to closed
    #
    # @return [void]
    def call
      return unless mr

      mr.update_attributes!(state: "closed")
    end

    private

    attr_reader :project, :mr_iid

    # Opened merge request
    #
    # @return [MergeRequest]
    def mr
      @mr ||= Project.find_by(name: project).merge_requests.where(iid: mr_iid, state: "opened").first
    end
  end
end
