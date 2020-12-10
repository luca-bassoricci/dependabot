# frozen_string_literal: true

# Common logger class
#
class DependabotLogger
  DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"

  class SimpleLogFormatter < Sidekiq::Logger::Formatters::Base
    # :reek:LongParameterList
    def call(severity, time, _program_name, message)
      "[#{time} tid=#{tid}#{format_context}] #{severity}: #{message}\n"
    end
  end

  def self.logger
    Logger.new(STDOUT).tap do |log|
      log.formatter = SimpleLogFormatter.new
      log.datetime_format = DATETIME_FORMAT
    end
  end
end
