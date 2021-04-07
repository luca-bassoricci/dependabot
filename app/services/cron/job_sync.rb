# frozen_string_literal: true

module Cron
  class JobSync < ApplicationService
    # @param [Project] project
    def initialize(project)
      @project = project
    end

    # Sync cron jobs and return array
    #
    # @return [Array<Sidekiq::Cron::Job>]
    def call
      sync_jobs
      project_jobs
    end

    private

    attr_reader :project

    # Dependabot configuration
    #
    # @return [Hash]
    def config
      @config ||= project.symbolized_config
    end

    # Project name
    #
    # @return [String]
    def project_name
      @project_name ||= project.name
    end

    # Persist project jobs
    #
    # @return [Sidekiq::Cron::Job]
    def project_jobs
      @project_jobs ||= config.map do |opts|
        package_ecosystem = opts[:package_ecosystem]
        directory = opts[:directory]

        Sidekiq::Cron::Job.new(
          name: "#{project_name}:#{package_ecosystem}:#{directory}",
          cron: opts[:cron],
          class: "DependencyUpdateJob",
          args: { "project_name" => project_name, "package_ecosystem" => package_ecosystem, "directory" => directory },
          active_job: true,
          description: "Update #{package_ecosystem} dependencies for #{project_name} in #{directory}"
        ).tap(&:save)
      end
    end

    # Destroy jobs not present in config anymore
    #
    # @return [void]
    def sync_jobs
      ProjectJobFinder.call(project_name)
                      .reject { |job| project_jobs.any? { |jb| jb.name == job.name } }
                      .each(&:destroy)
    end
  end
end
