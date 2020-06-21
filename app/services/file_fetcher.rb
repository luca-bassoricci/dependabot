# frozen_string_literal: true

class FileFetcher < ApplicationService
  # Get specific file fetcher
  # @param [Dependabot::Source] source
  # @param [String] package_manager
  # @return [Dependabot::FileFetchers]
  def call(source, package_manager = "bundler")
    Dependabot::FileFetchers.for_package_manager(package_manager).new(
      source: source,
      credentials: Credentials.call
    )
  end
end
