# frozen_string_literal: true

module Dependabot
  class DependencyFetcher < ApplicationService
    # @param [Hash] params
    # @option params [Dependabot::Source] :source
    # @option params [Array<Dependabot::DependencyFile>] :dependency_files
    # @option params [String] :package_manager
    # @option params [Array<String>] :allowed_dependencies
    # @option params [Array<String>] :allowed_dependency_types
    # @option params [Array<String>] :ignored_dependencies
    # @option params [Array<String>] :ignored_dependency_types
    # @option params [Number] :open_merge_requests
    def initialize(**params)
      @params = params
    end

    # Get dependency list
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      dependencies
    end

    private

    attr_reader :params

    # Dependency list
    #
    # @return [Array<Dependabot::Dependency>]
    def dependencies
      @dependencies ||= FileParser.call(**params).select(&:top_level?)
    end
  end
end
