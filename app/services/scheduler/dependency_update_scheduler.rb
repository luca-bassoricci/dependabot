# frozen_string_literal: true

module Scheduler
  class DependencyUpdateScheduler < ApplicationService
    # @param [String] repo
    def initialize(repo)
      @repo = repo
    end

    # Create cron job and run it
    #
    # @return [Array<Sidekiq::Cron::Job>]
    def call
      config.map do |opts|
        package_ecosystem = opts[:package_ecosystem]
        directory = opts[:directory]

        job = Sidekiq::Cron::Job.new(
          name: "#{repo}:#{package_ecosystem}:#{directory}",
          cron: opts[:cron],
          class: "DependencyUpdateJob",
          args: { "repo" => repo, "package_ecosystem" => package_ecosystem, "directory" => directory },
          active_job: true,
          description: "Update #{package_ecosystem} dependencies for #{repo} in #{directory}"
        )

        run(job)
      end
    end

    private

    attr_reader :repo

    # Dependabot configuration
    #
    # @return [Hash]
    def config
      @config ||= Dependabot::Config.call(repo, update_cache: true)
    end

    # Save and run a job or print error message
    #
    # @param [Sidekiq::Cron::Job] job
    # @return [Sidekiq::Cron::Job]
    def run(job)
      job.valid? ? enque(job) : logger.error { job.errors }
      job
    end

    # Save and enque job
    #
    # @param [Sidekiq::Cron::Job] job
    # @return [Sidekiq::Cron::Job]
    def enque(job)
      job.save && job.enque!
    end
  end
end
