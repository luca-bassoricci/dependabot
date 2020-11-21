# frozen_string_literal: true

module Api
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |error|
        Raven.capture_exception(error)
        ApplicationHelper.log_error(error)

        json_response(body: { status: 500, error: error.message }, status: 500)
      end
    end
  end
end
