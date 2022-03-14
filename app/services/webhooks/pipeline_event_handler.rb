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
    def initialize(source:, status:, project_name:, mr_iid:, merge_status:)
      @source = source
      @status = status
      @project_name = project_name
      @mr_iid = mr_iid
      @merge_status = merge_status
    end

    def call
      return unless actionable? && mr.auto_merge

      accept
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    private

    attr_reader :project_name, :mr_iid, :source, :status, :merge_status

    # Accept merge request
    #
    # @return [Hash]
    def accept
      gitlab.accept_merge_request(project_name, mr_iid)
      log(:info, "Accepted merge request !#{mr_iid}")

      { merge_request_accepted: true }
    rescue Gitlab::Error::MethodNotAllowed => e
      log(:error, "Failed to accept merge requests !#{mr_iid}. Error: #{e.message}")
      { merge_request_accepted: false }
    end

    # Is event actionable
    #
    # @return [Boolean]
    def actionable?
      source == "merge_request_event" && status == "success" && merge_status != "cannot_be_merged"
    end

    # Config entry for particular ecosystem and directory
    #
    # @return [Hash]
    def config
      @config ||= project.config.entry(package_ecosystem: mr.package_ecosystem, directory: mr.directory)
    end

    def mr
      @mr ||= project.merge_requests.find_by(iid: mr_iid, state: "opened")
    end

    # Current project
    #
    # @return [Project]
    def project
      @project ||= Project.find_by(name: project_name)
    end
  end
end
