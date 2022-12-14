# frozen_string_literal: true

module Webhooks
  class PipelineEventHandler < HookHandler
    # Handle pipeline event
    #
    # @param [String] source
    # @param [String] status
    # @param [String] project
    # @param [Number] mr_iid
    # @param [String] merge_status
    def initialize(**args)
      super(args[:project_name])

      @source = args[:source]
      @status = args[:status]
      @mr_iid = args[:mr_iid]
      @merge_status = args[:merge_status]
      @source_project_id = args[:source_project_id]
      @target_project_id = args[:target_project_id]
    end

    def call
      return unless actionable? && mr.auto_merge

      accept
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    private

    attr_reader :mr_iid,
                :source,
                :status,
                :merge_status,
                :source_project_id,
                :target_project_id

    # Accept merge request
    #
    # @return [Hash]
    def accept
      log(:info, "Accepting merge request !#{mr_iid}")
      g_mr = gitlab.accept_merge_request(project_name, mr_iid, squash: mr.squash).to_h
      raise "Failed to accept merge request !#{mr_iid}. Error: #{g_mr['merge_error']}" if g_mr["merge_error"].present?

      { merge_request_accepted: true }
    rescue Gitlab::Error::MethodNotAllowed => e
      raise "Failed to accept merge request !#{mr_iid}. Error: #{e.message}"
    end

    # Is event actionable
    #
    # @return [Boolean]
    def actionable?
      mr? && !fork? && success? && can_merge?
    end

    # Is a merge request pipeline
    #
    # @return [Boolean]
    def mr?
      source == "merge_request_event"
    end

    # Successfull pipeline
    #
    # @return [Boolean]
    def success?
      status == "success"
    end

    # Can be merged
    #
    # @return [Boolean]
    def can_merge?
      merge_status != "cannot_be_merged"
    end

    # Is forked merge request pipeline
    #
    # @return [Boolean]
    def fork?
      source_project_id != target_project_id
    end

    # Merge request
    #
    # @return [MergeRequest]
    def mr
      @mr ||= project.merge_requests.find_by(iid: mr_iid, state: "opened")
    end
  end
end
