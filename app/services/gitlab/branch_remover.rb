# frozen_string_literal: true

module Gitlab
  class BranchRemover < ApplicationService
    def initialize(project_name, branch)
      @project_name = project_name
      @branch = branch
    end

    # Delete project branch
    #
    # @return [void]
    def call
      return unless branch

      log(:debug, "Removing branch '#{branch}'")
      gitlab.delete_branch(project_name, branch)
    end

    private

    attr_reader :project_name, :branch
  end
end
