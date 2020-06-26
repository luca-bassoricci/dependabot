# frozen_string_literal: true

class ApplicationService
  include ApplicationHelper

  def self.call(*args)
    new(*args).call
  end

  delegate :logger, to: :Rails
end
