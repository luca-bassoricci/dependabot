# frozen_string_literal: true

module Gitlab
  class MergeRequestAcceptor < ApplicationService
    # @param [Gitlab::ObjectifiedHash] merge_request
    def initialize(merge_request)
      @mr = merge_request
    end

    # Accept merge request
    #
    # @return [Gitlab::ObjectifiedHash]
    def call
      logger.info { "accepting merge request #{mr.references.short}" }
      gitlab.accept_merge_request(
        mr.project_id,
        mr.iid,
        merge_when_pipeline_succeeds: true
      )
    rescue Gitlab::Error::MethodNotAllowed, Gitlab::Error::NotAcceptable => e
      logger.error { "failed to accept merge request: #{e.message}" }
    end

    private

    attr_reader :mr
  end
end