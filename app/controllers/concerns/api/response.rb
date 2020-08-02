# frozen_string_literal: true

module Api
  module Response
    def json_response(object, status = 200)
      render(json: object, status: status)
    end
  end
end
