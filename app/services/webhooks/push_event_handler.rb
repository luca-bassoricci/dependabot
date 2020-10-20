# frozen_string_literal: true

module Webhooks
  # :reek:InstanceVariableAssumption
  class PushEventHandler < ApplicationService
    # @param [ActionController::Parameters] params
    def initialize(params)
      @params = params
    end

    # Create or delete dependency update jobs
    #
    # @return [Array<Sidekiq::Cron::Job>] <description>
    def call
      return unless modified_config? || deleted_config?
      return delete_all_jobs if deleted_config?

      ::Scheduler::DependencyUpdateScheduler.call(project)
    end

    private

    attr_reader :params

    # Project name
    #
    # @return [String]
    def project
      @project ||= params.dig(:project, :path_with_namespace)
    end

    # Has dependabot config been modified
    #
    # @return [Boolean]
    def modified_config?
      params[:commits].any? do |commit|
        commit.values_at(:added, :modified).flatten.include?(Settings.config_filename)
      end
    end

    # Has dependabot config been deleted
    #
    # @return [Boolean]
    def deleted_config?
      return @deleted_config if defined?(@deleted_config)

      @deleted_config = params[:commits].any? do |commit|
        commit[:removed].include?(Settings.config_filename)
      end
    end

    # Delete dependency update jobs
    #
    # @return [void]
    def delete_all_jobs
      all_project_jobs(project).each(&:destroy)
    end
  end
end
