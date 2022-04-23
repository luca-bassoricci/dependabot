# frozen_string_literal: true

module Gitlab
  class ClientWithRetry
    RETRYABLE_ERRORS = [
      # gitlab might often fail to accept mr due to pipeline not starting fast enough
      Gitlab::Error::MethodNotAllowed,
      Gitlab::Error::NotAcceptable,
      Gitlab::Error::BadGateway
    ].freeze

    delegate :log, to: :ApplicationHelper

    def initialize
      @max_retries = 2
      @client = Gitlab.client(
        endpoint: "#{AppConfig.gitlab_url}/api/v4",
        private_token: CredentialsConfig.gitlab_access_token
      )
    end

    private

    # :reek:ManualDispatch
    def method_missing(method_name, *args, &block)
      retry_connection_failures do
        @client.respond_to?(method_name) ? @client.public_send(method_name, *args, &block) : super
      end
    end

    # :reek:ManualDispatch
    def respond_to_missing?(method_name, *)
      @client.respond_to?(method_name) || super
    end

    def retry_connection_failures
      retry_attempt = 0

      begin
        yield
      rescue *RETRYABLE_ERRORS => e
        retry_attempt += 1
        raise unless retry_attempt <= @max_retries

        log(:warn, "Gitlab request failed with: '#{e}'. Retrying...")
        retry
      end
    end
  end
end
