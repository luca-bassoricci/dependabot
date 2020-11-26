# frozen_string_literal: true

module Dependabot
  class Config < ApplicationService
    # @param [String] project_name
    # @param [String] default_branch
    # @param [Boolean] update_cache
    def initialize(project_name, default_branch, update_cache: false)
      @project_name = project_name
      @default_branch = default_branch
      @update_cache = update_cache
    end

    # Dependabot config hash
    #
    # @return [Hash<Symbol, Object>]
    def call
      Rails.cache.fetch("#{project_name}-config", expires_in: 12.hours, force: update_cache) do
        Configuration::Parser.call(Gitlab::ConfigFetcher.call(project_name, default_branch))
      end
    end

    private

    attr_reader :project_name, :default_branch, :update_cache
  end
end
