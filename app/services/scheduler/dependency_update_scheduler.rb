# frozen_string_literal: true

module Scheduler
  class DependencyUpdateScheduler < ApplicationService
    # @param [String] project
    def initialize(project)
      @project = project
    end

    # Create cron job and run it
    #
    # @return [Array<Sidekiq::Cron::Job>]
    def call
      sync_jobs
      enque_all_jobs
    end

    private

    attr_reader :project

    # Dependabot configuration
    #
    # @return [Hash]
    def config
      @config ||= Dependabot::Config.call(project, update_cache: true)
    end

    # Currently configured project cron jobs
    #
    # @return [Array<Sidekiq::Cron::Job>]
    def project_jobs
      @project_jobs ||= config.map do |opts|
        package_ecosystem = opts[:package_ecosystem]
        directory = opts[:directory]

        Sidekiq::Cron::Job.new(
          name: "#{project}:#{package_ecosystem}:#{directory}",
          cron: opts[:cron],
          class: "DependencyUpdateJob",
          args: { "repo" => project, "package_ecosystem" => package_ecosystem, "directory" => directory },
          active_job: true,
          description: "Update #{package_ecosystem} dependencies for #{project} in #{directory}"
        )
      end
    end

    # Destroy jobs not present in config anymore
    #
    # @return [void]
    def sync_jobs
      all_project_jobs(project).reject { |job| project_jobs.any? { |jb| jb.name == job.name } }.each(&:destroy)
    end

    # Save and enque all jobs
    #
    # @return [Array<Sidekiq::Cron::Job>]
    def enque_all_jobs
      project_jobs.tap { |jobs| jobs.each { |job| run(job) } }
    end

    # Save and run a job or print error message
    #
    # @param [Sidekiq::Cron::Job] job
    # @return [Sidekiq::Cron::Job]
    def run(job)
      job.valid? ? (job.save && job.enque!) : logger.error { job.errors }
      job
    end
  end
end
