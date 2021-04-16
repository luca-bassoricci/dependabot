# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Acceptor < ApplicationService
      # Accept existing merge request
      #
      # @param [String] project_name
      # @param [Number] mr_iid
      # @param [Hash] opts
      # @option opts [Boolean] :merge_when_pipeline_succeeds
      def initialize(project_name, mr_iid, opts = {})
        @project_name = project_name
        @mr_iid = mr_iid
        @opts = opts
      end

      # Accept merge request
      #
      # @return [Gitlab::ObjectifiedHash]
      def call
        gitlab.accept_merge_request(project_name, mr_iid, opts)
      end

      private

      attr_reader :project_name, :mr_iid, :opts
    end
  end
end
