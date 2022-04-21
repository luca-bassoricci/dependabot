# frozen_string_literal: true

require "graphql/client"
require "graphql/client/http"

module Github
  module Graphql
    class QueryError < StandardError; end

    GITHUB_GQL_API_ENDPOINT = "https://api.github.com/graphql"

    HTTPAdapter = GraphQL::Client::HTTP.new(GITHUB_GQL_API_ENDPOINT) do
      def headers(_context)
        { "Authorization" => "Bearer #{CredentialsConfig.github_access_token}" }
      end
    end

    Schema = GraphQL::Client.load_schema("db/schema.json")

    # Github graphql client
    #
    # @return [GraphQL::Client]
    def client
      @client ||= GraphQL::Client.new(schema: Schema, execute: HTTPAdapter)
    end

    module_function :client
  end
end
