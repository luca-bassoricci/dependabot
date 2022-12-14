# frozen_string_literal: true

module Dependabot
  module Projects
    # Create or update Project
    #
    class Creator < ApplicationService
      # @param [String] project_name
      def initialize(project_name, access_token = nil)
        @project_name = project_name
        @access_token = access_token
      end

      # Create or update existing project
      #
      # @return [Project] response info
      def call
        Gitlab::ClientWithRetry.client_access_token = access_token if access_token

        validate_project_exists

        save_webhook
        save_project
      end

      private

      attr_reader :project_name, :access_token

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
      # @return [Project]
      def save_project
        project.id = gitlab_project.id
        project.web_url = gitlab_project.web_url
        project.configuration = config if config
        project.gitlab_access_token = access_token if access_token
        project.forked_from_id = forked_from[:forked_from_id]
        project.forked_from_name = forked_from[:forked_from_name]
        project.save!

        project
      end

      # Existing project
      #
      # @return [Project]
      def project
        @project ||= Project.find_or_initialize_by(name: project_name)
      end

      # Dependabot configuration
      #
      # @return [Array]
      def config
        @config ||= begin
          branch = DependabotConfig.config_branch || default_branch
          return unless Gitlab::ConfigFile::Checker.call(project_name, branch)

          Config::Fetcher.call(project_name, branch: branch, update_cache: true)
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
      rescue NoMethodError
        raise "Project '#{project_name}' is missing default branch"
      end

      # Parent project id if exists
      #
      # @return [Hash]
      def forked_from
        @forked_from ||= begin
          id = gitlab_project.to_h.dig("forked_from_project", "id")
          name = gitlab_project.to_h.dig("forked_from_project", "path_with_namespace")

          { forked_from_id: id, forked_from_name: name }
        end
      end

      alias_method :validate_project_exists, :gitlab_project
    end
  end
end
