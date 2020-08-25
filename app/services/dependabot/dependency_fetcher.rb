# frozen_string_literal: true

module Dependabot
  class DependencyFetcher < ApplicationService
    # @param [Dependabot::Source] :source
    # @param [Array<Dependabot::DependencyFile>] :dependency_files
    # @param [String] :package_manager
    def initialize(source:, dependency_files:, package_manager:)
      @source = source
      @dependency_files = dependency_files
      @package_manager = package_manager
    end

    # Get dependency list
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      FileParser.call(
        dependency_files: dependency_files,
        source: source,
        package_manager: package_manager
      )
    end

    private

    attr_reader :source, :dependency_files, :package_manager
  end
end
