# frozen_string_literal: true

module Webhooks
  class MergeRequestEventHandler < ApplicationService
    # @param [String] project
    # @param [String] mr_iid
    def initialize(project, mr_iid)
      @project = project
      @mr_iid = mr_iid
    end

    # Set merge request state to closed
    #
    # @return [void]
    def call
      merge_request&.yield_self do |mr|
        log(:info, "Setting merge request !#{mr.iid} state to closed!")
        mr.update_attributes!(state: "closed")

        { closed_merge_request: true }
      end
    end

    private

    attr_reader :project, :mr_iid

    # Opened merge request
    #
    # @return [<MergeRequest, nil>]
    def merge_request
      @merge_request ||= Project
                         .find_by(name: project)
                         .merge_requests
                         .find_by(iid: mr_iid, state: "opened")
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end
end
