# frozen_string_literal: true

module Gitlab
  # Check for projects containing the config file
  #
  class ProjectFinder < ApplicationService
    # Get all unregistered projects with present configuration
    #
    # @return [Array<String>]
    def call
      projects = gitlab.projects(min_access_level: 30, per_page: 100).auto_paginate
      log(:debug, "Fetched #{projects.length} projects")

      projects
        .select { |project| !registered?(project.path_with_namespace) && config_present?(project) }
        .map(&:path_with_namespace)
    end

    private

    # Check configuration is present
    #
    # @param [Gitlab::ObjectifiedHash] project
    # @return [Boolean]
    def config_present?(project)
      project_name = project.path_with_namespace
      Config::Checker.call(project_name, project.default_branch).tap do |present|
        next log(:debug, "  found config for project '#{project_name}', proceeding...") if present

        log(:debug, "  config not found for project '#{project_name}', skipping...")
      end
    end

    # Check project already registered
    #
    # @param [String] project_name
    # @return [Boolean]
    def registered?(project_name)
      Project.find_by(name: project_name).tap do
        log(:debug, "  project '#{project_name}' already registered, skipping...")
      end && true
    rescue Mongoid::Errors::DocumentNotFound
      false
    end
  end
end
