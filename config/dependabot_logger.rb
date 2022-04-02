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
      prefix = "[#{time}#{thread}#{clazz}] #{severity.ljust(5)} -- "
      msg = "#{message}\n"

      Rainbow(prefix).send(LOG_COLORS.fetch(severity, :silver)) + msg
    end

    def thread
      tid ? " tid=#{tid}" : ""
    end

    def clazz
      ctx[:class] ? " class=#{ctx[:class]}" : ""
    end
  end

  # Common tagged logger
  #
  # @param [String] log_source
  # @return [ActiveSupport::TaggedLogging]
  def self.logger(log_source)
    logdev = AppConfig.log_path ? "#{AppConfig.log_path}/#{log_source}.out" : $stdout
    ActiveSupport::TaggedLogging.new(
      Logger.new(logdev).tap do |log|
        log.formatter = SimpleLogFormatter.new
        log.datetime_format = DATETIME_FORMAT
        log.level = AppConfig.log_level
      end
    )
  end
end
