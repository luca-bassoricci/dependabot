# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include Response
    include ExceptionHandler

    before_action :authenticate

    private

    # Authenticate request against gitlab token
    #
    # @return [void]
    def authenticate
      gitlab_auth_token = CredentialsConfig.gitlab_auth_token
      return unless gitlab_auth_token

      gitlab_token = request.headers.fetch("X-Gitlab-Token", "")
      return if ActiveSupport::SecurityUtils.secure_compare(gitlab_token, gitlab_auth_token)

      json_response(body: { status: 401, error: "Invalid gitlab authentication token" }, status: 401)
    end
  end
end
