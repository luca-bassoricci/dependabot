# frozen_string_literal: true

class UpdateFailures
  class << self
    # Reset run errors
    #
    # @return [void]
    def reset
      Thread.current[:errors] = []
    end

    # Capture update job error
    #
    # @param [Error] error
    # @return [void]
    def save_error(error)
      errors << error.message
    end

    # Current failures
    #
    # @return [Array]
    def errors
      return reset unless Thread.current[:errors]

      Thread.current[:errors]
    end
  end
end
