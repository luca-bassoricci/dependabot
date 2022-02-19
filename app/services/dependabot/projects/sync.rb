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
        log(:info, "Running project registration")
        log(:info, "Processing only projects matching pattern '#{allowed_pattern}'") if allowed_pattern

        gitlab.projects(min_access_level: 30, per_page: 50).auto_paginate do |project|
          log(:info, "Processing project '#{project.path_with_namespace}'")
          next unless sync?(project)

          register(project)
        end
      end

      private

      # Check if project should be synced
      #
      # @param [Gitlab::ObjectifiedHash] project
      # @return [Boolean]
      def sync?(project)
        name = project.path_with_namespace

        unless project["default_branch"]
          log(:debug, " project '#{name}' doesn't have a default branch, skipping")
          return
        end

        !allowed_pattern || name.match?(Regexp.new(allowed_pattern)).tap do |match|
          log(:debug, " project '#{name}' doesn't match pattern '#{allowed_pattern}', skipping") unless match
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
      def register(project) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        project_name = project.path_with_namespace

        existing_project = saved_project(name: project_name) || saved_project(id: project.id)
        conf = config(project)

        if !existing_project && !conf
          log(:info, " project '#{project_name}' has no #{config_file}, skipping")
        elsif existing_project && existing_project.name != project_name
          rename_project(existing_project, project_name)
        elsif !existing_project && conf
          register_project(project_name, "not added for updates, registering")
        elsif existing_project && !conf
          remove_project(project_name)
        elsif !jobs_synced?(project_name, conf)
          register_project(project_name, "jobs out of sync, updating")
        else
          log(:info, "  project '#{project_name}' is up to date, skipping")
        end
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
      # @param [Hash] args
      # @return [Boolean]
      def saved_project(**args)
        Project.find_by(args)
      rescue Mongoid::Errors::DocumentNotFound
        nil
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
        log(:info, "  project '#{project_name}' #{log_message}")
        project = Creator.call(project_name)

        log(:info, "  adding dependency update jobs")
        Cron::JobSync.call(project)
      end

      # Remove project
      #
      # @param [String] project_name
      # @return [void]
      def remove_project(project_name)
        log(:info, "  #{config_file} removed for '#{project_name}', removing from dependency updates")
        Remover.call(project_name)
      end

      # Rename project
      #
      # @param [Project] project
      # @param [String] new_project_name
      # @return [void]
      def rename_project(project, new_project_name)
        old_project_name = project.name
        log(:info, " renaming project '#{old_project_name}' to '#{new_project_name}'")

        project.update_attributes!(name: new_project_name)

        Cron::JobRemover.call(old_project_name)
        Cron::JobSync.call(project)
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
