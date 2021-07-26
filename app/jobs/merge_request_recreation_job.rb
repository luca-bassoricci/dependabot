# frozen_string_literal: true

# Recreate merge request
#
class MergeRequestRecreationJob < ApplicationJob
  queue_as :hooks
  sidekiq_options retry: 0

  # Perform merge request recreation
  #
  # @param [String] project_name
  # @param [Number] mr_iid
  # @param [String] discussion_id
  # @return [void]
  def perform(project_name, mr_iid, discussion_id)
    @project_name = project_name
    @mr_iid = mr_iid
    @discussion_id = discussion_id

    reply_status(":warning: `dependabot` is recreating merge request. All changes will be overwritten! :warning:")
    Dependabot::MergeRequestUpdater.call(project_name: project_name, mr_iid: mr_iid)
    reply_status(":white_check_mark: `dependabot` successfuly recreated merge request!")
  rescue StandardError => e
    log_error(e)
    reply_status(":x: `dependabot` failed recreating merge request.\n\n```\n#{e.message}\n```")
  end

  private

  attr_reader :project_name, :mr_iid, :discussion_id

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
