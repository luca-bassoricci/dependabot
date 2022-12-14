# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Commenter < ApplicationService
      # @param [String] project
      # @param [Integer] mr_iid
      # @param [String] comment
      def initialize(project, mr_iid, comment)
        @project = project
        @mr_iid = mr_iid
        @comment = comment
      end

      # Create a note on merge request
      #
      # @return [void]
      def call
        log(:debug, "Posting #{comment} on mr #{mr_iid}")
        gitlab.create_merge_request_note(project, mr_iid, comment)
      end

      private

      attr_reader :project, :mr_iid, :comment
    end
  end
end
