# frozen_string_literal: true

class ProjectRegistrationJob < ApplicationJob
  queue_as :project_registration

  sidekiq_options retry: 2, dead: false

  def perform
    set_execution_context("project-registration")
    log(:info, "Checking for projects to register or update")
    Dependabot::Projects::Registration::Service.call
  ensure
    clear_execution_context
  end
end
