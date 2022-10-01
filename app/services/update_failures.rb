# frozen_string_literal: true

class UpdateFailures
  class << self
    # Capture update job error
    #
    # @param [Error] error
    # @return [void]
    def add(error)
      fetch.push({
        message: error.message,
        backtrace: error.backtrace
      })
    end

    # Current failures
    #
    # @return [Array]
    def fetch
      RequestStore.fetch(:errors) { [] }
    end
  end
end
