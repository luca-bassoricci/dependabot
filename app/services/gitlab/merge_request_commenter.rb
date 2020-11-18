# frozen_string_literal: true

module Gitlab
  class MergeRequestCommenter < ApplicationService
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
      logger.debug { "Posting #{comment} on mr #{mr_iid}" }
      gitlab.create_merge_request_note(project, mr_iid, comment)
    end

    private

    attr_reader :project, :mr_iid, :comment
  end
end
