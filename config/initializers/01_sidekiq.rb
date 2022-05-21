# frozen_string_literal: true

redis_conf = {
  password: ENV["REDIS_PASSWORD"],
  timeout: 1,
  reconnect_attempts: 3,
  logger: DependabotLogger.logger(source: "redis", logdev: :file)
}
logger = DependabotLogger
         .logger(source: "sidekiq")
         .extend(ActiveSupport::Logger.broadcast(DependabotLogger.db_logger))

Sidekiq.configure_server do |config|
  Yabeda::Prometheus::Exporter.start_metrics_server! if AppConfig.metrics

  config.logger = logger
  config.redis = redis_conf
  config.options[:queues].push("hooks", "project_registration", "vulnerability_update")
end

Sidekiq.configure_client do |config|
  config.logger = logger
  config.redis = redis_conf
end

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

      Sidekiq::Context.add(:elapsed, elapsed(start))
      log(level, "done")
    rescue Exception # rubocop:disable Lint/RescueException
      Sidekiq::Context.add(:elapsed, elapsed(start))
      log(level, "fail")

      raise
    end

    def log(level, message)
      @logger.public_send(level, message)
    end
  end
end
