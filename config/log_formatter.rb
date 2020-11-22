# frozen_string_literal: true

DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"

# Custom log formatter
#
class SimpleLogFormatter < Sidekiq::Logger::Formatters::Base
  # :reek:LongParameterList
  def call(severity, time, _program_name, message)
    "[#{time} tid=#{tid}] #{severity}: #{message}\n"
  end
end
