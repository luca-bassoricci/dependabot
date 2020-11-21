# frozen_string_literal: true

module Dependabot
  # Create or update Project
  #
  class ProjectCreator < ApplicationService
    # @param [String] project_name
    def initialize(project_name)
      @project_name = project_name
    end

    # Create or update existing project
    #
    # @return [Array] response info
    def call
      project.config = config
      project.tap(&:save!)
    end

    private

    attr_reader :project_name

    # Existing project
    #
    # @return [Project]
    def project
      @project ||= Project.where(name: project_name).first || Project.new(name: project_name)
    end

    # Dependabot configuration
    #
    # @return [Array]
    def config
      @config ||= Configuration::Parser.call(Gitlab::ConfigFetcher.call(project_name))
    end
  end
end
