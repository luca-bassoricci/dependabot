# frozen_string_literal: true

module Dependabot
  class ProjectRemover < ApplicationService
    def initialize(project_name)
      @project_name = project_name
    end

    def call
      remove_project
      delete_all_jobs
    end

    private

    attr_reader :project_name

    # Delete project
    #
    # @return [void]
    def remove_project
      log(:info, "Removing project: #{project_name}")
      Project.find_by(name: project_name).destroy
    rescue Mongoid::Errors::DocumentNotFound
      log(:error, "Project #{project_name} doesn't exist!")
    end

    # Delete dependency update jobs
    #
    # @return [void]
    def delete_all_jobs
      Cron::JobRemover.call(project_name)
    end
  end
end
