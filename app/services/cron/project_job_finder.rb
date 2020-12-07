# frozen_string_literal: true

module Cron
  class ProjectJobFinder < ApplicationService
    def initialize(project_name)
      @project_name = project_name
    end

    # Find all project related jobs
    #
    # @return [Array<Sidekiq::Cron::Job>]
    def call
      Sidekiq::Cron::Job.all.select { |job| job.name.match?(/^#{project_name}:.*/) }
    end

    private

    attr_reader :project_name
  end
end
