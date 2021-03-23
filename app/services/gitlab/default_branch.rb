# frozen_string_literal: true

module Gitlab
  class DefaultBranch < ApplicationService
    # @param [String] project_name
    def initialize(project_name)
      @project_name = project_name
    end

    # Get default branch of project
    #
    # @return [String]
    def call
      Rails.cache.fetch("#{project_name}-branch", expires_in: 1.hour) do
        gitlab.project(project_name)&.default_branch || raise("Failed to fetch default branch for #{project_name}")
      end
    end

    private

    attr_reader :project_name
  end
end
