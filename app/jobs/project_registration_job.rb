# frozen_string_literal: true

class ProjectRegistrationJob < ApplicationJob
  queue_as :project_registration

  def perform
    log(:info, "Checking for projects to register")
    projects = Gitlab::ProjectFinder.call.yield_self do |prjs|
      next prjs unless allowed_pattern

      prjs.select { |name| allowed?(name) }
    end
    return log(:info, "No new unregistered projects found, quitting!") if projects.empty?

    projects.each do |project_name|
      log(:info, "  Registering project '#{project_name}'")
      project = Dependabot::ProjectCreator.call(project_name)
      Cron::JobSync.call(project)
    end
  end

  private

  # Allowed project namespace pattern
  #
  # @return [String, nil]
  def allowed_pattern
    @allowed_pattern ||= AppConfig.project_registration_namespace
  end

  # Project namespace allowed
  #
  # @param [String] project_name
  # @return [Boolean]
  def allowed?(project_name)
    allowed_pattern = AppConfig.project_registration_namespace
    return true unless allowed_pattern

    project_name.match?(Regexp.new(allowed_pattern))
  end
end
