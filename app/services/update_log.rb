# frozen_string_literal: true

class UpdateLog
  class << self
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
      RequestStore.fetch(:log) { [] }
    end
  end
end
