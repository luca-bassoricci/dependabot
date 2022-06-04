# frozen_string_literal: true

Healthcheck.configure do |config|
  config.success = 200
  config.error = 503
  config.verbose = false
  config.route = "/healthcheck"
  config.method = :get

  # -- Checks --
  config.add_check :database, lambda {
    begin
      Mongoid.default_client.database_names.present?
    rescue StandardError => e
      ApplicationHelper.log(:error, "MongoDB healthcheck failed - #{e.message}", tags: ["Healthcheck"])
      raise e
    end
  }
  config.add_check :redis, lambda {
    begin
      Redis.new(password: ENV["REDIS_PASSWORD"], timeout: 1, reconnect_attempts: 1).tap do |redis|
        redis.ping
        redis.close
      end
    rescue StandardError => e
      ApplicationHelper.log(:error, "Redis healthcheck failed - #{e.message}", tags: ["Healthcheck"])
      raise e
    end
  }
end
