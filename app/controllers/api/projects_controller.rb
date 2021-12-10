# frozen_string_literal: true

module Api
  class ProjectsController < ApplicationController
    # List all registered projects
    #
    # @return [String]
    def index
      json_response(body: Project.all.map(&:sanitized_hash))
    end

    # Return single project
    #
    # @return [String]
    def show
      args = project_id.is_a?(Integer) ? { id: project_id } : { name: project_id }
      json_response(body: Project.find_by(**args).sanitized_hash)
    end

    # Add new project or update existing one and schedule jobs
    #
    # @return [String]
    def create
      log(:info, "Registering project '#{project_name}'")
      project = Dependabot::ProjectCreator.call(project_name)
      Cron::JobSync.call(project)
      json_response(body: project.sanitized_hash)
    rescue ActionController::ParameterMissing
      json_response(body: { status: 400, error: "Missing parameter 'project'" }, status: 400)
    end

    # Remove project
    #
    # @return [String]
    def destroy
      Dependabot::ProjectRemover.call(project_id)
    end

    private

    # Project name
    #
    # @return [String]
    def project_name
      params.require(:project)
    end

    # Project id or full path
    #
    # @return [Integer, String]
    def project_id
      id = params[:id]
      return id unless id.match?(/\d/)

      id.to_i
    end
  end
end
