# frozen_string_literal: true

module Api
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |e|
        json_response({ message: e.message }, 500)
      end
    end
  end
end
