# frozen_string_literal: true

class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  delegate :logger, to: :Rails
end
