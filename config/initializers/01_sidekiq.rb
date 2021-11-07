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
  config.options[:queues].push("hooks", "project_registration")
end

Sidekiq.configure_client do |config|
  config.logger = logger
  config.redis = redis_conf
end

Redis.exists_returns_integer = true

# Reduce verbose output of activejob
ActiveJob::Base.logger = Logger.new(IO::NULL)

# Log healthcheck start/stop to debug level
# :reek:InstanceVariableAssumption
# :reek:RepeatedConditional
# :reek:TooManyStatements
module Sidekiq
  class JobLogger
    def call(_item, queue)
      start = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
      level = queue.start_with?("sidekiq_alive-") ? :debug : :info

      log(level, "start")

      yield

      with_elapsed_time_context(start) do
        log(level, "done")
      end
    rescue Exception # rubocop:disable Lint/RescueException
      with_elapsed_time_context(start) do
        log(level, "fail")
      end

      raise
    end

    def log(level, message)
      @logger.public_send(level, message)
    end
  end
end
