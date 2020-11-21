# frozen_string_literal: true

module Api
  module Response
    # Render reponse as json
    #
    # @param [Object] object
    # @param [Number] status response status
    # @return [void]
    def json_response(body:, status: 200)
      args = body ? { json: body, status: status } : { json: {}, status: 204 }
      render(**args)
    end
  end
end
