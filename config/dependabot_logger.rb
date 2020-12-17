# frozen_string_literal: true

# Common logger class
#
class DependabotLogger
  DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"

  class SimpleLogFormatter < Sidekiq::Logger::Formatters::Base
    # :reek:LongParameterList
    def call(severity, time, _program_name, message)
      "[#{time}#{thread}#{clazz}] #{severity}: #{message}\n"
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
  # @return [ActiveSupport::TaggedLogging]
  def self.logger
    ActiveSupport::TaggedLogging.new(
      Logger.new($stdout).tap do |log|
        log.formatter = SimpleLogFormatter.new
        log.datetime_format = DATETIME_FORMAT
        log.level = Sidekiq::LoggingUtils::LEVELS[AppConfig.log_level]
      end
    )
  end
end
