# frozen_string_literal: true

module Dependabot
  class FileFetcher < ApplicationService
    attr_reader :source, :package_manager

    # Get specific file fetcher
    # @param [Dependabot::Source] source
    # @param [String] package_manager
    def initialize(source:, package_manager:)
      @source = source
      @package_manager = package_manager
    end

    # Get FileFetcher
    #
    # @return [Dependabot::FileFetcher]
    def call
      Dependabot::FileFetchers.for_package_manager(package_manager).new(
        source: source,
        credentials: Credentials.fetch
      )
    end
  end
end
