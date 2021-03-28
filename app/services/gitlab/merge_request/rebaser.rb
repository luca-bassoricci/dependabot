# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Rebaser < ApplicationService
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
        log(:info, "Rebasing mr with iid: #{mr_iid}")
        gitlab.rebase_merge_request(project, mr_iid)
      end

      private

      attr_reader :project, :mr_iid
    end
  end
end
