# frozen_string_literal: true

class UpdateLog
  class << self
    # Reset run logs
    #
    # @return [void]
    def reset
      Thread.current[:log] = []
    end

    # Capture log entry
    #
    # @param [Hash] entry
    # @return [void]
    def add(entry)
      log << entry
    end

    # Current run log
    #
    # @return [Array<Hash>]
    def log
      return reset unless Thread.current[:log]

      Thread.current[:log]
    end
  end
end
