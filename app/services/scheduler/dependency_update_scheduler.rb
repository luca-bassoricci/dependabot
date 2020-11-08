# frozen_string_literal: true

module Scheduler
  class DependencyUpdateScheduler < ApplicationService
    # @param [String] project
    def initialize(project)
      @project = project
    end

    # Sync state and create/update jobs
    #
    # @return [Array<Sidekiq::Cron::Job>]
    def call
      update_project
      sync_jobs
      enque_all_jobs
    end

    private

    attr_reader :project

    # Dependabot configuration
    #
    # @return [Hash]
    def config
      @config ||= Configuration::Parser.call(Gitlab::ConfigFetcher.call(project))
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

    # Update project
    #
    # @return [void]
    def update_project
      Project.find_by(name: project).update_attributes!(config: config)
    rescue Mongoid::Errors::DocumentNotFound
      Project.create!(name: project, config: config)
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
