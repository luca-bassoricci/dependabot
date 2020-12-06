# frozen_string_literal: true

class HealthcheckConfig < ApplicationConfig
  env_prefix :settings_

  attr_config queue: "healthcheck-#{ENV['HOSTNAME']}",
              filename: "/tmp/healthcheck.txt"
end
