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
  # @param [String] action
  # @return [void]
  def perform(project_name, mr_iid, action)
    set_execution_context("#{project_name}=>!#{mr_iid}")

    Dependabot::MergeRequest::UpdateService.call(
      project_name: project_name,
      mr_iid: mr_iid,
      action: action
    )
  rescue StandardError => e
    log_error(e)
    Gitlab::MergeRequest::Commenter.call(
      project_name,
      mr_iid,
      ":x: `dependabot` tried to update merge request but failed.\n\n```\n#{e}\n```"
    )
  ensure
    clear_execution_context
  end
end
