# frozen_string_literal: true

# Common logger class
#
class DependabotLogger
  DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"

  def self.logger
    Logger.new(STDOUT).tap do |log|
      log.datetime_format = DATETIME_FORMAT
      log.formatter = proc { |severity, time, _program_name, message| "[#{time}] #{severity}: #{message}\n" }
    end
  end
end
