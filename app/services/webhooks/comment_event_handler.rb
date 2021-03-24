# frozen_string_literal: true

module Webhooks
  class CommentEventHandler < ApplicationService
    COMMENT_PATTERN = /^\$dependabot (?<action>rebase|recreate)$/.freeze

    # @param [String] comment
    # @param [String] project
    # @param [Number] mr_iid
    def initialize(comment, project, mr_iid)
      @comment = comment
      @project = project
      @mr_iid = mr_iid
    end

    def call
      return unless actionable_comment?

      action_map[action].call
    end

    private

    attr_reader :comment, :project, :mr_iid

    # Action map
    #
    # @return [Hash]
    def action_map
      @action_map ||= {
        "rebase" => -> { Gitlab::MergeRequestRebaser.call(project, mr_iid) },
        "recreate" => -> { MergeRequestRecreationJob.perform_later(project, mr_iid) }
      }
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
  end
end
