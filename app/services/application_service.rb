# frozen_string_literal: true

class ApplicationService
  include ApplicationHelper

  def self.call(...)
    new(...).call
  end

  delegate :logger, to: :Rails
end
