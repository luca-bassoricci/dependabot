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
      save_webhook
      save_project
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
      @config ||= begin
        return nil unless Gitlab::ConfigChecker.call(project_name, default_branch)

        Config.call(project_name, default_branch, update_cache: true)
      end
    end

    # Project default branch
    #
    # @return [String]
    def default_branch
      @default_branch ||= Gitlab::DefaultBranch.call(project_name)
    end

    # Save webhook if dependabot url is configured
    #
    # @return [void]
    def save_webhook
      return unless AppConfig.dependabot_url

      (project.webhook_id || Gitlab::Hooks::Finder.call(project_name)).tap do |hook_id|
        return Gitlab::Hooks::Updater.call(project_name, default_branch, hook_id) if hook_id
      end

      project.webhook_id = Gitlab::Hooks::Creator.call(project_name, default_branch)
    end

    # Save project
    #
    # @return [void]
    def save_project
      project.config = config if config
      project.tap(&:save!)
    end
  end
end
