# frozen_string_literal: true

require "rainbow/refinement"

# Common logger class
#
class DependabotLogger
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

      # Save log messages in thread local variable to save in database
      UpdateLog.add("#{prefix}#{message}") if ctx[:class] == "DependencyUpdateJob"
      Rainbow(prefix).send(LOG_COLORS.fetch(severity, :silver)) + "#{message}\n"
    end

    def thread
      return "" if AppConfig.standalone?

      tid ? " tid=#{tid}" : ""
    end
  end

  class << self
    # Common tagged logger
    #
    # @param [String] source
    # @param [Object] logdev
    # @return [ActiveSupport::Logger]
    def logger(source:, logdev: :stdout)
      ActiveSupport::Logger.new(log_device(source, logdev)).tap do |log|
        log.formatter = SimpleLogFormatter.new
        log.level = AppConfig.log_level
      end
    end

    private

    # :reek:ControlParameter

    # Log device
    #
    # @param [String] source
    # @return [Object]
    def log_device(source, logdev)
      return "log/#{source}.log" if logdev == :file || !AppConfig.log_stdout

      $stdout
    end
  end
end
