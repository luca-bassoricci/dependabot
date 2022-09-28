# frozen_string_literal: true

module Gitlab
  class MilestoneFinder < ApplicationService
    def initialize(project, milestone_title)
      @project = project
      @milestone_title = milestone_title
    end

    # Fetch milestone id
    #
    # @return [Integer]
    def call
      return unless milestone_title
      return milestone_cache[milestone_title] if milestone_cache[milestone_title]

      log(:debug, "Running milestone search for #{milestone_title}")
      milestones = gitlab.milestones(project.name, title: milestone_title, include_parent_milestones: true)
      return log(:error, "Milestone with '#{milestone_title}' not found!") && nil if milestones.empty?

      milestone_cache[milestone_title] = milestones.first.id
    end

    private

    attr_reader :milestone_title, :project

    # Thread local milestone cache
    #
    # @return [Hash]
    def milestone_cache
      RequestStore.fetch(:milestones) { {} }
    end
  end
end
