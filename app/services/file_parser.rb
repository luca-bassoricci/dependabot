# frozen_string_literal: true

class FileParser < ApplicationService
  # Get specific file parser class
  # @param [Array<Dependabot::DependencyFile>] dependency_files
  # @param [Dependabot::Source] source
  # @param [String] package_manager
  # @return [Dependabot::FileParsers]
  def call(dependency_files:, source:, package_manager: "bundler")
    Dependabot::FileParsers.for_package_manager(package_manager).new(
      dependency_files: dependency_files,
      source: source,
      credentials: Credentials.call
    )
  end
end
