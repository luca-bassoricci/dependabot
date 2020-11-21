# frozen_string_literal: true

module Webhooks
  # :reek:InstanceVariableAssumption
  class PushEventHandler < ApplicationService
    # @param [String] project
    # @param [Array] commits
    def initialize(project_name, commits)
      @project_name = project_name
      @commits = commits
    end

    # Create or delete dependency update jobs
    #
    # @return [Project] <description>
    def call
      return unless modified_config? || deleted_config?
      return clean if deleted_config?

      Dependabot::ProjectCreator.call(project_name).tap do |project|
        Scheduler::DependencyUpdateScheduler.call(project)
      end
    end

    private

    attr_reader :project_name, :commits

    # Has dependabot config been modified
    #
    # @return [Boolean]
    def modified_config?
      commits.any? do |commit|
        commit.values_at(:added, :modified).flatten.include?(Settings.config_filename)
      end
    end

    # Has dependabot config been deleted
    #
    # @return [Boolean]
    def deleted_config?
      return @deleted_config if defined?(@deleted_config)

      @deleted_config = commits.any? do |commit|
        commit[:removed].include?(Settings.config_filename)
      end
    end

    # Clean up after removing config
    #
    # @return [void]
    def clean
      remove_project
      delete_all_jobs
    end

    # Delete project
    #
    # @return [void]
    def remove_project
      logger.info { "Removing project: #{project_name}" }
      Project.find_by(name: project_name).destroy
    rescue Mongoid::Errors::DocumentNotFound
      logger.error { "Project #{project_name} doesn't exist!" }
    end

    # Delete dependency update jobs
    #
    # @return [void]
    def delete_all_jobs
      logger.info { "Removing all dependency update jobs for project: #{project_name}" }
      all_project_jobs(project_name).each(&:destroy)
    end
  end
end
