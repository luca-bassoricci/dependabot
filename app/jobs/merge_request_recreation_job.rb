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

    set_execution_context("mr-update: #{project_name}=>!#{mr_iid}")

    recreate
  rescue StandardError => e
    log_error(e)
    reply_status(":x: `dependabot` failed recreating merge request.\n\n```\n#{e}\n```")
  ensure
    clear_execution_context
  end

  private

  attr_reader :project_name, :mr_iid, :discussion_id

  # Run mr recreate
  #
  # @return [void]
  def recreate
    reply_status(":warning: `dependabot` is recreating merge request. All changes will be overwritten! :warning:")

    Dependabot::MergeRequest::UpdateService.call(
      project_name: project_name,
      mr_iid: mr_iid,
      action: Dependabot::MergeRequest::UpdateService::RECREATE
    )

    reply_status(":white_check_mark: `dependabot` successfuly recreated merge request!")
    resolve_discussion
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
