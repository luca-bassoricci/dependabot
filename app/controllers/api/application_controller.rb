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
      Settings.gitlab_auth_token.tap do |gitlab_auth_token|
        gitlab_token = request.headers["X-Gitlab-Token"] || ""

        break if ActiveSupport::SecurityUtils.secure_compare(gitlab_token, gitlab_auth_token)

        json_response({ status: 401, error: "Invalid gitlab authentication token" }, 401)
      end
    end
  end
end
