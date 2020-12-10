# frozen_string_literal: true

module Gitlab
  class MergeRequestCloser < ApplicationService
    # @param [String] project
    # @param [Integer] mr_iid
    def initialize(project, mr_iid)
      @project = project
      @mr_iid = mr_iid
    end

    # Close merge request
    #
    # @return [void]
    def call
      logger.info { "Closing mr with iid: #{mr_iid}" }
      gitlab.update_merge_request(project, mr_iid, state_event: "close")
    end

    private

    attr_reader :project, :mr_iid
  end
end