# frozen_string_literal: true

# Update single merge request
#
class MergeRequestUpdateJob < ApplicationJob
  queue_as :hooks
  sidekiq_options retry: 0

  # Perform merge request update/rebase
  #
  # @param [String] project_name
  # @param [Number] mr_iid
  # @return [void]
  def perform(project_name, mr_iid)
    note = Gitlab::MergeRequest::Commenter.call(
      project_name,
      mr_iid,
      "`dependabot` is updating merge request!"
    )
    Dependabot::MergeRequest::UpdateService.call(project_name: project_name, mr_iid: mr_iid, recreate: false)
  rescue StandardError => e
    Gitlab::MergeRequest::DiscussionReplier.call(
      project_name: project_name,
      mr_iid: mr_iid,
      discussion_id: note.id,
      note: ":x: Dependabot failed to update mr.\n\n```\n#{e}\n```"
    )
  end
end
