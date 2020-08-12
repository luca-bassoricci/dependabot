# frozen_string_literal: true

module Api
  module Response
    # Render reponse as json
    #
    # @param [Object] object
    # @param [Number] status response status
    # @return [void]
    def json_response(object, status = 200)
      render(json: object, status: status)
    end
  end
end
