# frozen_string_literal: true

module Dependabot
  class Config < ApplicationService
    # @param [String] repo
    # @param [Boolean] update_cache
    def initialize(repo, update_cache: false)
      @repo = repo
      @update_cache = update_cache
    end

    # Dependabot config hash
    #
    # @return [Hash<Symbol, Object>]
    def call
      Rails.cache.fetch("#{repo}-config", expires_in: 12.hours, force: update_cache) do
        Configuration::Parser.call(Gitlab::ConfigFetcher.call(repo))
      end
    end

    private

    attr_reader :repo, :update_cache
  end
end
