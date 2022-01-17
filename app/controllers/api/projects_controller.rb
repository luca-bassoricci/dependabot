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
      json_response(body: project.sanitized_hash)
    end

    # Add new project or update existing one and schedule jobs
    #
    # @return [String]
    def create
      log(:info, "Registering project '#{project_name}'")
      project = Dependabot::Projects::Creator.call(project_name)
      Cron::JobSync.call(project)
      json_response(body: project.sanitized_hash)
    rescue ActionController::ParameterMissing
      json_response(body: { status: 400, error: "Missing parameter 'project'" }, status: 400)
    end

    # Update project attributes
    #
    # @return [String]
    def update
      project.update_attributes!(**params.permit(
        :name,
        :forked_from_id,
        :webhook_id,
        :web_url,
        :config
      ))
      json_response(body: project.sanitized_hash)
    end

    # Remove project
    #
    # @return [String]
    def destroy
      Dependabot::Projects::Remover.call(project_id)
    end

    private

    # Find project
    #
    # @return [Project]
    def project
      @project ||= begin
        args = project_id.is_a?(Integer) ? { id: project_id } : { name: project_id }
        Project.find_by(**args)
      end
    end

    # Project name
    #
    # @return [String]
    def project_name
      @project_name ||= params.require(:project)
    end

    # Project id or full path
    #
    # @return [Integer, String]
    def project_id
      @project_id ||= begin
        id = params[:id]
        return id unless id.match?(/\d/)

        id.to_i
      end
    end
  end
end
