# frozen_string_literal: true

class UpdateLog
  class << self
    # Reset run logs
    #
    # @return [void]
    def reset
      Thread.current[:log] = []
    end

    # Capture log message
    #
    # @param [String] message
    # @return [void]
    def add(message)
      log << message
    end

    # Current run log
    #
    # @return [Array]
    def log
      return reset unless Thread.current[:log]

      Thread.current[:log]
    end
  end
end
