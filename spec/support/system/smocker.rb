# frozen_string_literal: true

require "httparty"

module Support
  class Smocker
    include HTTParty
    base_uri ENV["MOCK_URL"]

    # Reset mock session
    #
    # @return [Hash]
    def reset
      resp = self.class.post("/reset")
      response(resp)
    end

    # Verify mock calls
    #
    # @return [Hash]
    def verify
      resp = self.class.post("/sessions/verify")
      response(resp)
    end

    # Add mock definition
    #
    # @param [String] mock
    # @return [Hash]
    def add(*mock)
      resp = self.class.post("/mocks", body: mock.join("\n"), headers: { "content-type" => "application/x-yaml" })
      response(resp)
    end

    private

    # Parse mock response
    #
    # @param [Response] resp
    # @return [Hash]
    def response(resp)
      raise("Invalid call to mock server") if resp.code != 200

      JSON.parse(resp.body, symbolize_names: true)
    end
  end
end
