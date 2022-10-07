# frozen_string_literal: true

class AppConfig < ApplicationConfig
  URL_REGEX = %r{^(.*?)(/+)?$}.freeze

  env_prefix :settings_

  attr_config :dependabot_url,
              gitlab_url: "https://gitlab.com",
              standalone: false,
              log_level: "info",
              log_color: false,
              log_stdout: true,
              create_project_hook: true,
              # mr command prefix
              commands_prefix: "$dependabot",
              # update job configuration
              update_retry: 2,
              expire_run_data: 1.month.to_i,
              # /metrics endpoint
              metrics: false,
              # project registration
              project_registration: "manual",
              project_registration_cron: "0 6 * * *",
              project_registration_namespace: nil,
              # sentry configuration
              sentry_traces_sample_rate: 0.0,
              sentry_ignored_errors: nil

  # Gitlab url with removed trailing slash
  #
  # @return [String]
  def gitlab_url
    sanitize_url(super)
  end

  # Dependabot url with removed trailing slash
  #
  # @return [String]
  def dependabot_url
    sanitize_url(super)
  end

  # Configurable sidekiq retry
  #
  # @return [Numeric, Boolean]
  def sidekiq_retry
    update_retry.is_a?(Numeric) ? update_retry : update_retry == "true"
  end

  # Deployment integrated with gitlab
  #
  # @return [Boolean]
  def integrated?
    dependabot_url && create_project_hook
  end

  private

  # Remove trailing slash from url
  #
  # @param [String] url
  # @return [URI]
  def sanitize_url(url)
    return unless url

    URI.parse(url.match(URL_REGEX)[1])
  end
end
