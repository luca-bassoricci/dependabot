# frozen_string_literal: true

module Api
  class ProjectController < ApplicationController
    # Manually add jobs for specific project or run updates if it already exists
    #
    # @return [void]
    def create
      json_response(::Scheduler::DependencyUpdateScheduler.call(project))
    rescue ActionController::ParameterMissing
      json_response({ status: 400, error: "Missing parameter 'project'" }, 400)
    end

    private

    # Project name
    #
    # @return [String]
    def project
      params.require(:project)
    end
  end
end
