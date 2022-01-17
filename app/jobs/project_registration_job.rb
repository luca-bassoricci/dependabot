# frozen_string_literal: true

class ProjectRegistrationJob < ApplicationJob
  queue_as :project_registration

  def perform
    log(:info, "Checking for projects to register or update")
    Dependabot::Projects::Sync.call
  end
end
