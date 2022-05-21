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
      prefix = DependabotLogger.message_prefix(time, thread, severity)

      Rainbow(prefix).send(LOG_COLORS.fetch(severity, :silver)) + "#{message}\n"
    end

    def thread
      tid ? " tid=#{tid}" : ""
    end
  end

  class DbLogFormatter < Sidekiq::Logger::Formatters::Base
    # :reek:LongParameterList
    def call(severity, time, _program_name, message)
      prefix = DependabotLogger.message_prefix(time, thread, severity)

      UpdateLog.add("#{prefix}#{message}")
    end

    def thread
      tid ? " tid=#{tid}" : ""
    end
  end

  class << self
    # Common tagged logger
    #
    # @param [String] source
    # @param [Object] logdev
    # @return [ActiveSupport::TaggedLogging]
    def logger(source:, logdev: nil)
      ActiveSupport::TaggedLogging.new(
        ActiveSupport::Logger.new(log_device(source, logdev)).tap do |log|
          log.formatter = SimpleLogFormatter.new
          log.datetime_format = DATETIME_FORMAT
          log.level = AppConfig.log_level
        end
      )
    end

    def db_logger
      ActiveSupport::TaggedLogging.new(
        ActiveSupport::Logger.new(IO::NULL).tap do |log|
          log.formatter = DbLogFormatter.new
          log.datetime_format = DATETIME_FORMAT
          log.level = AppConfig.log_level
        end
      )
    end

    def message_prefix(time, thread, severity)
      "[#{time}#{thread}] #{severity.ljust(5)} -- "
    end

    private

    # Log device
    #
    # @param [String] source
    # @return [Object]
    def log_device(source, logdev)
      logfile = "log/#{source}.out"

      return logfile if logdev == :file
      return logdev unless logdev.nil?
      return $stdout if AppConfig.log_stdout

      logfile
    end
  end
end
