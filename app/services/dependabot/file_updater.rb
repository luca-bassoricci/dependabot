# frozen_string_literal: true

module Dependabot
  class FileUpdater < ApplicationService
    attr_reader :dependencies, :dependency_files

    # @param [Array<Dependabot::Dependency>] dependencies
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    def initialize(dependencies:, dependency_files:)
      @dependencies = dependencies
      @dependency_files = dependency_files
    end

    # Get update checker
    #
    # @return [Array<Dependabot::DependencyFile>]
    def call
      Dependabot::FileUpdaters.for_package_manager(dependencies.first.package_manager).new(
        dependencies: dependencies,
        dependency_files: dependency_files,
        credentials: Credentials.call
      ).updated_dependency_files
    end
  end
end
