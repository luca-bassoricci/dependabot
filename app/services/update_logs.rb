# frozen_string_literal: true

class UpdateLogs
  class << self
    # Capture log entry
    #
    # @param [String] level
    # @param [String] message
    # @return [void]
    def add(level:, message:)
      msg = message.strip.capitalize.gsub(/\e\[(\d+)(?:;\d+)*m/, "")

      fetch.push({
        timestamp: Time.zone.now,
        level: level,
        message: msg
      })
    end

    # Current run log
    #
    # @return [Array<Hash>]
    def fetch
      RequestStore.fetch(:log) { [] }
    end
  end
end
