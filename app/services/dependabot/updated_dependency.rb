# frozen_string_literal: true

module Dependabot
  # Updated dependency container
  #
  class UpdatedDependency
    # @param [String] name
    # @param [Array<Dependabot::Dependency>] dependencies
    # @param [Array<Dependabot::DependencyFile>] updated_files
    # @param [Boolean] vulnerable
    def initialize(name:, updated_dependencies:, updated_files:, vulnerable:, security_advisories:)
      @name = name
      @updated_dependencies = updated_dependencies
      @updated_files = updated_files
      @vulnerable = vulnerable
      @security_advisories = security_advisories
    end

    # @return [String] main dependency name
    attr_reader :name
    # @return [Array<Dependabot::Dependency>] updated dependencies
    attr_reader :updated_dependencies
    # @return [Array<Dependabot::DependencyFile>] updated files
    attr_reader :updated_files
    # @return [Boolean]
    attr_reader :vulnerable
    # @return [Array<String> security advisories
    attr_reader :security_advisories

    # Object comparator
    # @param [UpdatedDependency] other
    # @return [Booelan]
    def ==(other)
      self.class == other.class && state == other.state
    end

    protected

    # Object state
    # @return [Array]
    def state
      instance_variables.map { |var| instance_variable_get(var) }
    end
  end
end
