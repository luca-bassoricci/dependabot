# frozen_string_literal: true

module Api
  class ProjectController < ApplicationController
    # Add new project or update existing one and schedule jobs
    #
    # @return [void]
    def create
      logger.info { "Registering project '#{project_name}'" }
      project = Dependabot::ProjectCreator.call(project_name)
      Cron::JobSync.call(project)
      json_response(body: project)
    rescue ActionController::ParameterMissing
      json_response(body: { status: 400, error: "Missing parameter 'project'" }, status: 400)
    end

    private

    # Project name
    #
    # @return [String]
    def project_name
      params.require(:project)
    end
  end
end
