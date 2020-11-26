# frozen_string_literal: true

module Gitlab
  module Hooks
    class ProjectHook < ApplicationService
      # @param [Project] project
      # @param [String] default_branch
      def initialize(project, default_branch)
        @project = project
        @default_branch = default_branch
        @dependabot_url = Settings.dependabot_url
        @hook_url = "#{@dependabot_url}/api/hooks"
      end

      private

      attr_reader :project, :default_branch, :dependabot_url, :hook_url

      # Hook creation arguments
      #
      # @return [Hash]
      def hook_args
        @hook_args ||= begin
          args = {
            merge_requests_events: true,
            push_events_branch_filter: default_branch,
            enable_ssl_verification: URI(dependabot_url).scheme == "https"
          }
          args[:token] = Settings.gitlab_auth_token if Settings.gitlab_auth_token
          args
        end
      end
    end
  end
end
