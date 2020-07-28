# frozen_string_literal: true

module Webhooks
  class PushEventHandler < ApplicationService
    # @param [ActionController::Parameters] params
    def initialize(params)
      @params = params
    end

    def call
      return unless modified_config? || deleted_config?
      return delete_schedules if deleted_config?

      ::Scheduler::DependencyUpdateScheduler.call(repo)
    end

    private

    attr_reader :params

    def repo
      @repo ||= params.dig(:project, :path_with_namespace)
    end

    def modified_config?
      return @modified_config if defined?(@modified_files)

      @updated_config = params[:commits].any? do |commit|
        commit.values_at(:added, :modified).flatten.include?(Settings.config_filename)
      end
    end

    def deleted_config?
      return @deleted_config if defined?(@deleted_config)

      @deleted_config = params[:commits].any? do |commit|
        commit[:removed].include?(Settings.config_filename)
      end
    end

    def delete_schedules
      Sidekiq::Cron::Job.all.each { |job| job.destroy if job.name.include?(repo) }
    end
  end
end
