# frozen_string_literal: true

class UpdateFailures
  class << self
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
      RequestStore.fetch(:errors) { [] }
    end
  end
end
