# frozen_string_literal: true

class Semaphore
  class << self
    delegate :synchronize, to: :mutex

    # Global mutex instance
    #
    # @return [Mutex]
    def mutex
      @mutex ||= Mutex.new
    end
  end
end
