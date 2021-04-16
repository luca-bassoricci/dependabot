# frozen_string_literal: true

module Gitlab
  module Hooks
    class ProjectHook < ApplicationService
      # @param [String] project_name
      # @param [Integer] webhook_id
      # @param [String] default_branch
      def initialize(project_name, default_branch = nil, webhook_id = nil)
        @project_name = project_name
        @default_branch = default_branch
        @webhook_id = webhook_id
        @dependabot_url = AppConfig.dependabot_url
        @hook_url = "#{@dependabot_url}/api/hooks"
      end

      private

      attr_reader :project_name, :webhook_id, :default_branch, :dependabot_url, :hook_url

      # Hook creation arguments
      #
      # @return [Hash]
      def hook_args
        @hook_args ||= begin
          args = {
            merge_requests_events: true,
            note_events: true,
            pipeline_events: true,
            push_events_branch_filter: default_branch,
            enable_ssl_verification: URI(dependabot_url).scheme == "https"
          }
          CredentialsConfig.gitlab_auth_token.tap { |token| args[:token] = token if token }
          args
        end
      end
    end
  end
end
