# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Acceptor < ApplicationService
      # @param [Gitlab::ObjectifiedHash] merge_request
      def initialize(merge_request)
        @mr = merge_request
      end

      # Accept merge request
      #
      # @return [Gitlab::ObjectifiedHash]
      def call
        gitlab.accept_merge_request(
          mr.project_id,
          mr.iid,
          merge_when_pipeline_succeeds: true
        )
      end

      private

      attr_reader :mr
    end
  end
end
