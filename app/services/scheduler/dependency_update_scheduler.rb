# frozen_string_literal: true

module Scheduler
  class DependencyUpdateScheduler < ApplicationService
    def initialize(repo)
      @repo = repo
    end

    def call
      config.map do |package_manager, opts|
        job = Sidekiq::Cron::Job.new(
          name: "#{repo}:#{package_manager}",
          cron: opts[:cron],
          class: "DependencyUpdateJob",
          args: { repo: repo, package_manager: package_manager },
          active_job: true,
          description: "Update #{package_manager} dependencies for #{repo} in #{opts[:directory]}"
        )

        run(job)
      end
    end

    private

    attr_reader :repo

    def config
      @config ||= Configuration::Parser.call(Gitlab::ConfigFetcher.call(repo))
    end

    def run(job)
      job.tap { |jb| jb.valid? ? jb.save && jb.enque! : logger.error { job.errors } }
    end
  end
end
