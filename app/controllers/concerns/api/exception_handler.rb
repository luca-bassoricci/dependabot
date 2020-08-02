# frozen_string_literal: true

module Api
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |e|
        Raven.capture_exception(e)
        json_response({ status: 500, error: e.message }, 500)
      end
    end
  end
end
