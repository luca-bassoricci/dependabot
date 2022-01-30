# frozen_string_literal: true

module Dependabot
  module Projects
    # Sync all applicable projects
    #
    class Sync < ApplicationService
      # Get all unregistered projects with present configuration
      #
      # @return [void]
      def call
        projects = gitlab.projects(min_access_level: 30, per_page: 100).auto_paginate
        log(:info, "Fetched #{projects.length} projects")
        log(:info, "Processing projects matching pattern '#{allowed_pattern}'") if allowed_pattern

        projects.each { |project| sync?(project) && sync(project) }
      end

      private

      # Check if project should be synced
      #
      # @param [Gitlab::ObjectifiedHash] project
      # @return [Boolean]
      def sync?(project)
        name = project.path_with_namespace

        unless project["default_branch"]
          log(:debug, "Project '#{name}' doesn't have a default branch, skipping...")
          return
        end

        !allowed_pattern || name.match?(Regexp.new(allowed_pattern)).tap do |match|
          log(:debug, "Project '#{name}' doesn't match pattern '#{allowed_pattern}', skipping...") unless match
        end
      end

      # Allowed project namespace pattern
      #
      # @return [String, nil]
      def allowed_pattern
        @allowed_pattern ||= AppConfig.project_registration_namespace
      end

      # :reek:TooManyStatements

      # Register or sync project
      #
      # @param [Gitlab::ObjectifiedHash] project
      # @return [Boolean]
      def sync(project) # rubocop:disable Metrics/CyclomaticComplexity
        project_name = project.path_with_namespace
        log(:info, "Processing project '#{project_name}'")

        proj = saved_project(project_name)
        conf = config(project)

        return log(:info, "Project '#{project_name}' has no #{config_file}, skipping") if !proj && !conf
        return register_project(project_name, "not added for updates, registering") if !proj && conf
        return remove_project(project_name) if proj && !conf
        return register_project(project_name, "jobs out of sync, updating") unless jobs_synced?(project_name, conf)

        log(:info, "Skipping '#{project_name}', project is up to date")
      end

      # Get project config
      #
      # @param [Gitlab::ObjectifiedHash] project
      # @return [Config, nil]
      def config(project)
        Config::Fetcher.call(
          project.path_with_namespace,
          branch: DependabotConfig.config_branch || project.default_branch,
          update_cache: true
        )
      rescue Config::MissingConfigurationError
        nil
      end

      # Saved project
      #
      # @param [String] project_name
      # @return [Boolean]
      def saved_project(project_name)
        Project.find_by(name: project_name)
      rescue Mongoid::Errors::DocumentNotFound
        false
      end

      # Check jobs synced
      #
      # @param [String] name
      # @param [Array] config
      # @return [Boolean]
      def jobs_synced?(project_name, config)
        cron_jobs = all_project_jobs(project_name).map { |job| { name: job.name, cron: job.cron } }

        configured_jobs = config.map do |conf|
          {
            name: "#{project_name}:#{conf[:package_ecosystem]}:#{conf[:directory]}",
            cron: conf[:cron]
          }
        end

        cron_jobs.sort_by { |job| job[:name] } == configured_jobs.sort_by { |job| job[:name] }
      end

      # Register project
      #
      # @param [String] project_name
      # @return [void]
      def register_project(project_name, log_message)
        log(:info, "Project '#{project_name}' #{log_message}")
        project = Creator.call(project_name)

        log(:info, "Adding dependency update jobs")
        Cron::JobSync.call(project)
      end

      # Remove project
      #
      # @param [String] project_name
      # @return [void]
      def remove_project(project_name)
        log(:info, "#{config_file} removed for '#{project_name}', removing from dependency updates")
        Remover.call(project_name)
      end

      # Config filename
      #
      # @return [String]
      def config_file
        @config_file ||= DependabotConfig.config_filename
      end
    end
  end
end
