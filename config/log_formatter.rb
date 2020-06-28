# frozen_string_literal: true

DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"

class SimpleLogFormatter < Sidekiq::Logger::Formatters::Base
  # :reek:LongParameterList
  def call(severity, time, _program_name, message)
    "[#{time} pid=#{::Process.pid} tid=#{tid}#{format_context}] #{severity}: #{message}\n"
  end
end
