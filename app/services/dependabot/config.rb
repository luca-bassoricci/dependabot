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
      update_cache ? fetch : fetch_cached
    end

    private

    attr_reader :repo, :update_cache

    # Cache key
    #
    # @return [String]
    def key
      @key ||= "#{repo}-config"
    end

    # Fetch config from cache
    #
    # @return [Hash<Symbol, Object>]
    def fetch_cached
      Rails.cache.fetch(key, expires_in: 24.hours) do
        Configuration::Parser.call(Gitlab::ConfigFetcher.call(repo))
      end
    end

    # Fetch config and save it in cache
    #
    # @return [Hash<Symbol, Object>]
    def fetch
      Configuration::Parser.call(Gitlab::ConfigFetcher.call(repo)).tap do |config|
        Rails.cache.write(key, config, expires_in: 24.hours)
      end
    end
  end
end
