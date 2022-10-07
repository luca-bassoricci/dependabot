# frozen_string_literal: true

module Cron
  class JobSync < ApplicationService
    # @param [Project] project
    def initialize(project)
      @project = project
    end

    # Sync cron jobs and return array
    #
    # @return [Array<Update::Job>]
    def call
      return unless config

      sync_jobs
      saved_project_jobs
    end

    private

    # @return [Project]
    attr_reader :project

    # Dependabot configuration
    #
    # @return [Config]
    def config
      @config ||= project.configuration
    end

    # Destroy jobs not present in config anymore
    #
    # @return [void]
    def sync_jobs
      removed_jobs = project.update_jobs.where(
        "$nor" => saved_project_jobs.map do |job|
                    { package_ecosystem: job.package_ecosystem, directory: job.directory }
                  end
      )

      removed_jobs.each { |job| Sidekiq::Cron::Job.destroy(cron_job_name(job.package_ecosystem, job.directory)) }
      removed_jobs.destroy
    end

    # Persist project jobs
    #
    # @return [Update::Job]
    def saved_project_jobs
      @saved_project_jobs ||= config.updates.map { |opts| save_project_job(opts) }
    end

    # Persist project dependency update job
    #
    # @param [Hash] opts
    # @return [ProjectJob]
    def save_project_job(opts)
      package_ecosystem = opts[:package_ecosystem]
      directory = opts[:directory]

      Sidekiq::Cron::Job.new(
        name: cron_job_name(package_ecosystem, directory),
        cron: opts[:cron],
        class: "DependencyUpdateJob",
        args: { "project_name" => project.name, "package_ecosystem" => package_ecosystem, "directory" => directory },
        active_job: true,
        description: "Update #{package_ecosystem} dependencies for #{project.name} in #{directory}"
      ).tap(&:save)

      Update::Job.find_or_create_by(
        project: project,
        package_ecosystem: package_ecosystem,
        directory: directory
      ).tap do |job|
        job.cron = opts[:cron]
        job.save!
      end
    end

    # Cron job name
    #
    # @param [String] package_ecosystem
    # @param [String] directory
    # @return [String]
    def cron_job_name(package_ecosystem, directory)
      "#{project.name}:#{package_ecosystem}:#{directory}"
    end
  end
end
