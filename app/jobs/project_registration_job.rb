# frozen_string_literal: true

class ProjectRegistrationJob < ApplicationJob
  queue_as :project_registration

  sidekiq_options dead: false

  def perform
    log(:info, "Checking for projects to register or update")
    run_within_context("project-registration") { Dependabot::Projects::Registration::Service.call }
  end
end
