# frozen_string_literal: true

module Dependabot
  class FileParser < ApplicationService
    # @param [Array<Dependabot::DependencyFile>] dependency_files
    # @param [Dependabot::Source] source
    # @param [String] package_manager
    def initialize(dependency_files:, source:, repo_contents_path:, config:)
      @dependency_files = dependency_files
      @source = source
      @repo_contents_path = repo_contents_path
      @package_manager = config[:package_manager]
      @reject_external_code = config[:reject_external_code]
      @registries = config[:registries]
    end

    # Get parsed dependencies from files
    #
    # @return [Array<Dependabot::Dependency>]
    def call
      Dependabot::FileParsers.for_package_manager(package_manager).new(
        dependency_files: dependency_files,
        source: source,
        credentials: [*Credentials.call, *registries],
        repo_contents_path: repo_contents_path,
        reject_external_code: reject_external_code
      ).parse
    end

    private

    attr_reader :dependency_files,
                :source,
                :package_manager,
                :repo_contents_path,
                :reject_external_code,
                :registries
  end
end
