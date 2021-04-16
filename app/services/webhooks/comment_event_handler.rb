# frozen_string_literal: true

module Webhooks
  class CommentEventHandler < ApplicationService
    COMMENT_PATTERN = /^\$dependabot (?<action>rebase|recreate)$/.freeze

    # @param [String] discussion_id
    # @param [String] comment
    # @param [String] project_name
    # @param [Number] mr_iid
    def initialize(discussion_id, comment, project_name, mr_iid)
      @discussion_id = discussion_id
      @comment = comment
      @project_name = project_name
      @mr_iid = mr_iid
    end

    def call
      return unless actionable_comment?

      send(action)
    end

    private

    attr_reader :comment, :project_name, :mr_iid, :discussion_id

    # Trigger merge request rebase
    #
    # @return [Hash]
    def rebase
      Gitlab::MergeRequest::Rebaser.call(project_name, mr_iid)
      reply_status(":white_check_mark: `dependabot` successfully triggered merge request rebase!")
      { rebase_in_progress: true }
    rescue StandardError => e
      log_error(e)
      reply_status(":x: `dependabot` failed to trigger merge request rebase! `#{e.message}`")
      { rebase_in_progress: false }
    end

    # Trigger merge request recreate
    #
    # @return [void]
    def recreate
      MergeRequestRecreationJob.perform_later(project_name, mr_iid, discussion_id)
      { recreate_in_progress: true }
    end

    # Valid comment
    #
    # @return [Boolean]
    def actionable_comment?
      comment.match?(COMMENT_PATTERN)
    end

    # Action to run
    #
    # @return [String]
    def action
      comment.match(COMMENT_PATTERN)[:action]
    end

    # Add action status reply
    #
    # @param [String] message
    # @return [void]
    def reply_status(message)
      Gitlab::MergeRequest::DiscussionReplier.call(
        project_name: project_name,
        mr_iid: mr_iid,
        discussion_id: discussion_id,
        note: message
      )
    end
  end
end
