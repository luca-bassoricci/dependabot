# frozen_string_literal: true

class ApplicationService
  include ApplicationHelper

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  delegate :logger, to: :Rails
end
