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

module Sidekiq
  module Cron
    # Patch 'all' method to get rid of deprecation warnings until it is fixed upstream
    class Job
      # :reek:UncommunicativeVariableName
      # :reek:NestedIterators
      def self.all
        job_hashes = nil

        Sidekiq.redis do |conn|
          set_members = conn.smembers(jobs_key)
          job_hashes = conn.pipelined do |pipeline|
            set_members.each do |key|
              pipeline.hgetall(key)
            end
          end
        end

        job_hashes.compact.reject(&:empty?).collect do |h|
          # no need to fetch missing args from redis since we just got this hash from there
          Sidekiq::Cron::Job.new(h.merge(fetch_missing_args: false))
        end
      end
    end
  end
end
