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
        milestones = gitlab.milestones(project_name, title: title, include_parent_milestones: true)
        return log(:error, "Milestone with '#{title}' not found!") && nil if milestones.empty?

        milestones.first.id
      end
    end
  end
end
