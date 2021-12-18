# frozen_string_literal: true

module Gitlab
  class MilestoneFinder < ApplicationService
    # @param [String] project_name
    # @param [String] title
    def initialize(project_name, title)
      @project_name = project_name
      @title = title
    end

    # Get milestone id
    #
    # @return [Number]
    def call
      return unless title

      milestone
    end

    private

    attr_reader :project_name, :title

    # Find milestone
    #
    # @return [Integer]
    def milestone
      Rails.cache.fetch("milestone-#{project_name}-#{title}", expires_in: 1.week) do
        log(:debug, "Running milestone search for #{title}")

        id = gitlab.milestones(project_name, title: title)&.first&.id
        log(:error, "Milestone with '#{title}' not found!") unless id

        id
      end
    end
  end
end
