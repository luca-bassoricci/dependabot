# frozen_string_literal: true

module Webhooks
  class CommentEventHandler < HookHandler
    # @param [String] discussion_id
    # @param [String] note
    # @param [String] project_name
    # @param [Number] mr_iid
    def initialize(project_name:, discussion_id:, note:, mr_iid:)
      super(project_name)

      @discussion_id = discussion_id
      @comment = note
      @mr_iid = mr_iid
    end

    def call
      return unless actionable_comment? && mr?

      send(action)
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    private

    attr_reader :comment, :mr_iid, :discussion_id

    # Comment action pattern
    #
    # @return [Regexp]
    def comment_pattern
      @comment_pattern ||= /^#{Regexp.quote(AppConfig.commands_prefix)} (?<action>rebase|recreate)/
    end

    # Trigger merge request rebase
    #
    # @return [Hash]
    def rebase
      log(:info, "Rebasing mr !#{mr_iid}")
      gitlab.rebase_merge_request(project_name, mr_iid)
      reply_status(":white_check_mark: `dependabot` successfully triggered merge request rebase!")
      resolve_discussion

      { rebase_in_progress: true }
    rescue StandardError => e
      log_error(e)
      reply_status(":x: `dependabot` failed to trigger merge request rebase! `#{e}`")
      { rebase_in_progress: false }
    end

    # Trigger merge request recreate
    #
    # @return [void]
    def recreate
      MergeRequestRecreationJob.perform_later(
        project_name: project_name,
        mr_iid: mr_iid,
        discussion_id: discussion_id
      )

      { recreate_in_progress: true }
    end

    # Check mr exists
    #
    # @return [MergeRequest]
    def mr?
      Project.find_by(name: project_name)
             .merge_requests
             .find_by(iid: mr_iid)
    end

    # Valid comment
    #
    # @return [Boolean]
    def actionable_comment?
      comment.match?(comment_pattern)
    end

    # Action to run
    #
    # @return [String]
    def action
      comment.match(comment_pattern)[:action]
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

    # Resolve mr discussion
    #
    # @return [void]
    def resolve_discussion
      gitlab.resolve_merge_request_discussion(project_name, mr_iid, discussion_id, resolved: true)
    end
  end
end
