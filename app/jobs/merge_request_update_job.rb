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
    @project_name = project_name
    @mr_iid = mr_iid

    Dependabot::MergeRequestUpdater.call(project_name: project_name, mr_iid: mr_iid, recreate: false)
  end

  private

  attr_reader :project_name, :mr_iid
end
