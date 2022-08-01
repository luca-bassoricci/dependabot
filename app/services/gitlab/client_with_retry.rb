# frozen_string_literal: true

module Gitlab
  class ClientWithRetry
    class << self
      # Fetch currently stored gitlab client or return client with globally configured token
      #
      # @return [Gitlab::Client]
      def current
        RequestStore.fetch(:gitlab_client) { client(CredentialsConfig.gitlab_access_token) }
      end

      # :reek:ControlParameter

      # Store gitlab client with specific access token
      #
      # @param [String] access_token
      # @return [Gitlab::Client]
      def client_access_token=(access_token)
        RequestStore.store[:gitlab_client] ||= client(access_token || CredentialsConfig.gitlab_access_token)
      end

      private

      # Gitlab client with retries
      #
      # @param [String] access_token
      # @return [Gitlab::Client]
      def client(access_token)
        Dependabot::Clients::GitlabWithRetries.new(
          endpoint: "#{AppConfig.gitlab_url}/api/v4",
          private_token: access_token
        )
      end
    end
  end
end
