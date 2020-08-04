# frozen_string_literal: true

module Dependabot
  class Config < ApplicationService
    def initialize(repo, update_cache: false)
      @repo = repo
      @update_cache = update_cache
    end

    def call
      update_cache ? fetch : fetch_cached
    end

    private

    attr_reader :repo, :update_cache

    def key
      @key ||= "#{repo}-config"
    end

    def fetch_cached
      Rails.cache.fetch(key, expires_in: 24.hours) do
        Configuration::Parser.call(Gitlab::ConfigFetcher.call(repo))
      end
    end

    def fetch
      Configuration::Parser.call(Gitlab::ConfigFetcher.call(repo)).tap do |config|
        Rails.cache.write(key, config, expires_in: 24.hours)
      end
    end
  end
end
