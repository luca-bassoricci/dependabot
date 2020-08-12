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
      config.map do |package_manager, opts|
        job = Sidekiq::Cron::Job.new(
          name: "#{repo}:#{package_manager}",
          cron: opts[:cron],
          class: "DependencyUpdateJob",
          args: { "repo" => repo, "package_manager" => package_manager },
          active_job: true,
          description: "Update #{package_manager} dependencies for #{repo} in #{opts[:directory]}"
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
      job.tap { |jb| jb.valid? ? jb.save && jb.enque! : logger.error { job.errors } }
    end
  end
end
