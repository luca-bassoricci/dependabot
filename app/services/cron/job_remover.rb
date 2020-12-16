# frozen_string_literal: true

module Cron
  class JobRemover < ApplicationService
    def initialize(project_name)
      @project_name = project_name
    end

    # Destroy all project related jobs
    #
    # @return [void]
    def call
      log(:info, "Removing all dependency update jobs for project: #{project_name}")
      ProjectJobFinder.call(project_name).each(&:destroy)
    end

    private

    attr_reader :project_name
  end
end
