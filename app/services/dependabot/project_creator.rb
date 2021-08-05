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

    # Save webhook if dependabot url is configured
    #
    # @return [void]
    def save_webhook
      return unless AppConfig.dependabot_url && AppConfig.create_project_hook

      # Update webhook_id if hook exists on Gitlab but not in local database
      hook_id = (project.webhook_id || Gitlab::Hooks::Finder.call(project_name))
      return project.webhook_id = Gitlab::Hooks::Updater.call(project_name, default_branch, hook_id) if hook_id

      project.webhook_id = Gitlab::Hooks::Creator.call(project_name, default_branch)
    rescue Gitlab::Error::Forbidden => e
      log_error(e)
    end

    # Save project
    #
    # @return [void]
    def save_project
      project.config = config if config
      project.forked_from_id = forked_from_id if forked_from_id
      project.project_id = gitlab_project.id

      project.tap(&:save!)
    end

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
        return nil unless Gitlab::Config::Checker.call(project_name, default_branch)

        ConfigFetcher.call(project_name, update_cache: true)
      end
    end

    # Gitlab project
    #
    # @return [Gitlab::ObjectifiedHash]
    def gitlab_project
      @gitlab_project ||= gitlab.project(project_name)
    end

    # Project default branch
    #
    # @return [String]
    def default_branch
      @default_branch ||= gitlab_project.default_branch
    end

    # Parent project id if exists
    #
    # @return [Integer]
    def forked_from_id
      @forked_from_id ||= gitlab_project.dig(:forked_from_project, :id)
    end
  end
end
