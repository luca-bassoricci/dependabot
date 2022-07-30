# frozen_string_literal: true

module Webhooks
  class HookHandler < ApplicationService
    def initialize(project_name)
      @project_name = project_name
    end

    private

    attr_reader :project_name

    # Project
    #
    # @return [Project]
    def project
      @project ||= Project.find_by(name: project_name)
    end
  end
end
