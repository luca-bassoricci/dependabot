# frozen_string_literal: true

class ProjectRegistrationJob < ApplicationJob
  queue_as :project_registration

  def perform
    log(:info, "Checking for projects to register")
    projects = Gitlab::ProjectFinder.call
    return log(:info, "No new unregistered projects found, quitting!") if projects.empty?

    projects.each do |project_name|
      log(:info, "  Registering project '#{project_name}'")
      project = Dependabot::ProjectCreator.call(project_name)
      Cron::JobSync.call(project)
    end
  end
end
