# frozen_string_literal: true

module Gitlab
  # Check for projects containing the config file
  #
  class ProjectFinder < ApplicationService
    # Get all unregistered projects with present configuration
    #
    # @return [Array<String>]
    def call
      gitlab.projects(min_access_level: 30)
            .select { |project| config_present?(project) && !registered?(project.path_with_namespace) }
            .map(&:path_with_namespace)
    end

    private

    def config_present?(project)
      Config::Checker.call(project.path_with_namespace, project.default_branch)
    end

    def registered?(project_name)
      Project.find_by(name: project_name) && true
    rescue Mongoid::Errors::DocumentNotFound
      false
    end
  end
end
