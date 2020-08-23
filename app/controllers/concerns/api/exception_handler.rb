# frozen_string_literal: true

module Api
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |error|
        Raven.capture_exception(error)
        json_response({ status: 500, error: error.message }, 500)
      end
    end
  end
end
