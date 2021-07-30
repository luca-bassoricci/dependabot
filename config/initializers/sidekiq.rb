# frozen_string_literal: true

redis_conf = {
  password: ENV["REDIS_PASSWORD"],
  timeout: 1,
  reconnect_attempts: 3
}
logger = DependabotLogger.logger

Sidekiq.configure_server do |config|
  Yabeda::Prometheus::Exporter.start_metrics_server! if AppConfig.metrics

  config.logger = logger
  config.redis = redis_conf
  config.options[:queues].push("hooks", HealthcheckConfig.queue)
end

Sidekiq.configure_client do |config|
  config.logger = logger
  config.redis = redis_conf
end

Redis.exists_returns_integer = true

# Reduce verbose output of activejob
ActiveJob::Base.logger = Logger.new(IO::NULL)
