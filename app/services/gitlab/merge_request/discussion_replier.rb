# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class DiscussionReplier < ApplicationService
      # Reply to discussion
      #
      # @param [String] project_name
      # @param [Number] merge_request_iid
      # @param [String] discussion_id
      # @param [String] note
      def initialize(project_name:, mr_iid:, discussion_id:, note:)
        @project_name = project_name
        @mr_iid = mr_iid
        @discussion_id = discussion_id
        @note = note
      end

      def call
        gitlab.create_merge_request_discussion_note(project_name, mr_iid, discussion_id, body: note)
      end

      private

      attr_reader :project_name, :mr_iid, :discussion_id, :note
    end
  end
end
