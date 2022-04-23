# frozen_string_literal: true

module Github
  module Vulnerabilities
    class Fetcher < ApplicationService
      include Graphql

      PACKAGE_ECOSYSTEMS = {
        Dependabot::Ecosystem::BUNDLER => "RUBYGEMS",
        Dependabot::Ecosystem::COMPOSER => "COMPOSER",
        Dependabot::Ecosystem::GO => "GO",
        Dependabot::Ecosystem::MAVEN => "MAVEN",
        Dependabot::Ecosystem::NPM => "NPM",
        Dependabot::Ecosystem::PIP => "PIP",
        Dependabot::Ecosystem::NUGET => "NUGET"
      }.freeze

      GQL_QUERY = <<~GRAPHQL
        pageInfo {
          endCursor
          hasNextPage
        }
        nodes {
          advisory {
            databaseId
            summary
            description
            origin
            permalink
            publishedAt
            withdrawnAt
            references {
              url
            }
            identifiers {
              value
            }
          }
          firstPatchedVersion {
            identifier
          }
          package {
            name
          }
          severity
          vulnerableVersionRange
        }
      GRAPHQL

      SecurityVulnerabilityIndex = Graphql.client.parse <<~GRAPHQL
        query($package_ecosystem: SecurityAdvisoryEcosystem) {
          securityVulnerabilities(first: 100, ecosystem: $package_ecosystem) {
            #{GQL_QUERY}
          }
        }
      GRAPHQL

      SecurityVulnerabilityMore = Graphql.client.parse <<~GRAPHQL
        query($package_ecosystem: SecurityAdvisoryEcosystem, $end_cursor: String) {
          securityVulnerabilities(first: 100, ecosystem: $package_ecosystem, after: $end_cursor) {
            #{GQL_QUERY}
          }
        }
      GRAPHQL

      def self.call(package_ecosystem, &block)
        new(package_ecosystem).call(&block)
      end

      # Security vulnerability fetcher
      #
      # @param [String] package_ecosystem
      def initialize(package_ecosystem)
        @ecosystem = PACKAGE_ECOSYSTEMS.fetch(package_ecosystem)
        @max_retries = 2
      end

      # :reek:DuplicateMethodCall
      # :reek:TooManyStatements

      # Get vulnerabilities for package_ecosystem
      #
      # @return [Array]
      def call
        log(:debug, "Fetching vulnerabilities from GitHub advisory database")

        vulnerabilities = []
        page = 1

        current = query(page: page)
        page += 1

        vulnerabilities.push(*current.nodes)
        yield current.nodes if block_given?

        while current.page_info.has_next_page
          current = query(end_cursor: current.page_info.end_cursor, page: page)
          page += 1

          vulnerabilities.push(*current.nodes)
          yield current.nodes if block_given?
        end

        vulnerabilities
      end

      private

      attr_reader :ecosystem, :max_retries

      # Query security vulnerabilities
      #
      # @param [String] end_cursor
      # @param [Integer] page
      # @return [Object]
      def query(end_cursor: nil, page: 1)
        schema = end_cursor ? SecurityVulnerabilityMore : SecurityVulnerabilityIndex
        variables = { package_ecosystem: ecosystem, end_cursor: end_cursor }.compact_blank

        log(:debug, "  running graphql query, page: #{page}")
        retry_query_failures do
          response = client.query(schema, variables: variables)
          raise(QueryError, response.errors[:data].join(", ")) if response.errors.any?

          response.data.security_vulnerabilities
        end
      end

      # Retry on github querry error
      #
      # @return [Object]
      def retry_query_failures
        retry_attempt = 0

        begin
          yield
        rescue QueryError => e
          retry_attempt += 1

          log(:warn, "GitHub request failed with: '#{e}'. Retrying...")
          retry_attempt <= max_retries ? retry : raise
        end
      end
    end
  end
end
