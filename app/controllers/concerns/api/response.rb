# frozen_string_literal: true

module Api
  module Response
    # Render reponse as json
    #
    # @param [Object] object
    # @param [Number] status response status
    # @return [String]
    def json_response(body: nil, status: 200)
      args = body ? { json: body, status: status } : { json: {}, status: 202 }
      render(**args)
    end
  end
end
