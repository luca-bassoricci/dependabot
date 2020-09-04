# frozen_string_literal: true

module ApplicationHelper
  # Get gitlab client
  #
  # @return [Gitlab::Client]
  def gitlab
    Gitlab.client(
      endpoint: "#{Settings.gitlab_url}/api/v4",
      private_token: Settings.gitlab_access_token
    )
  end

  # Log error message and backtrace
  #
  # @param [StndardError] error
  # @return [void]
  # :reek:FeatureEnvy
  def log_error(error)
    Rails.logger.error { "#{error.message}\n#{error.backtrace&.join('\n')}" }
  end

  module_function :gitlab, :log_error
end
