# frozen_string_literal: true

module Webhooks
  class PipelineEventHandler < ApplicationService
    # Handle pipeline event
    #
    # @param [String] source
    # @param [String] status
    # @param [String] project
    # @param [Number] mr_iid
    # @param [String] merge_status
    def initialize(source, status, project_name, mr_iid, merge_status)
      @source = source
      @status = status
      @project_name = project_name
      @mr_iid = mr_iid
      @merge_status = merge_status
    end

    def call
      return unless actionable? && auto_merge

      accept
    end

    private

    attr_reader :project_name, :mr_iid, :source, :status, :merge_status

    # Is event actionable
    #
    # @return [Boolean]
    def actionable?
      source == "merge_request_event" && status == "success" && merge_status == "can_be_merged"
    end

    # Is mr set for auto merging
    #
    # @return [Boolean]
    def auto_merge
      @auto_merge ||= Project.find_by(name: project_name)
                             .merge_requests
                             .find_by(iid: mr_iid, state: "opened")
                             .auto_merge
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    # Accept merge request
    #
    # @return [Hash]
    def accept
      Gitlab::MergeRequest::Acceptor.call(project_name, mr_iid)
      log(:info, "Accepted merge request !#{mr_iid}")

      { merge_request_accepted: true }
    rescue Gitlab::Error::MethodNotAllowed => e
      log(:error, "Failed to accept merge requests !#{mr_iid}. Error: #{e.message}")
      { merge_request_accepted: false }
    end
  end
end
