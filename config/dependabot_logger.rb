# frozen_string_literal: true

require "rainbow/refinement"

# Common logger class
#
class DependabotLogger
  DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"
  LOG_COLORS = {
    "DEBUG" => :magenta,
    "INFO" => :green,
    "WARN" => :yellow,
    "ERROR" => :red
  }.freeze

  class SimpleLogFormatter < Sidekiq::Logger::Formatters::Base
    # :reek:LongParameterList
    def call(severity, time, _program_name, message)
      prefix = "[#{time}#{thread}] #{severity.ljust(5)} -- "
      msg = "#{message}\n"

      Rainbow(prefix).send(LOG_COLORS.fetch(severity, :silver)) + msg
    end

    def thread
      tid ? " tid=#{tid}" : ""
    end
  end

  # :reek:ControlParameter

  # Common tagged logger
  #
  # @param [String] source
  # @param [Boolean] stdout
  # @return [ActiveSupport::TaggedLogging]
  def self.logger(source:, stdout: AppConfig.log_stdout)
    logdev = stdout ? $stdout : "log/#{source}.out"
    ActiveSupport::TaggedLogging.new(
      Logger.new(logdev).tap do |log|
        log.formatter = SimpleLogFormatter.new
        log.datetime_format = DATETIME_FORMAT
        log.level = AppConfig.log_level
      end
    )
  end
end
