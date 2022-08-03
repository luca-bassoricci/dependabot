# frozen_string_literal: true

class UpdateLog
  class << self
    # Capture log entry
    #
    # @param [String] level
    # @param [String] message
    # @return [void]
    def add(level:, message:)
      msg = message.strip.capitalize.gsub(/\e\[(\d+)(?:;\d+)*m/, "")

      log.push({
        timestamp: Time.zone.now,
        level: level,
        message: msg
      })
    end

    # Current run log
    #
    # @return [Array<Hash>]
    def log
      RequestStore.fetch(:log) { [] }
    end
  end
end
