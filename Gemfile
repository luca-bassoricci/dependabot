# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 2.6"

gem "config", "~> 2.2"
gem "dependabot-omnibus", "~> 0.125.7"
gem "dry-validation", "~> 1.5"
gem "lograge", "~> 0.11.2"
gem "mongoid", "~> 7.1"
gem "puma", "~> 5.1"
gem "rails", "~> 6.0.3"
gem "rails-healthcheck", "~> 1.2"
gem "semantic_range", "~> 2.3"
gem "sentry-raven", "~> 3.1", require: false
gem "sidekiq", "~> 6.1.2"
gem "sidekiq-cron", "~> 1.2"

gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "bundle-audit", "~> 0.1.0", require: false
  gem "pry-rails", "~> 0.3.9"
  gem "reek", "~> 6.0", require: false
  gem "rubocop", "~> 0.93.1", require: false
  gem "rubocop-performance", "~> 1.9.1", require: false
  gem "rubocop-rails", "~> 2.8", require: false
  gem "rubocop-rspec", "~> 1.44", require: false
end

group :test do
  gem "brakeman", "~> 4.10"
  gem "climate_control", "~> 0.2.0"
  gem "faker", "~> 2.15"
  gem "rack-test", "~> 1.1"
  gem "rspec", "~> 3.10"
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "rspec-rails", "~> 4.0.1"
  gem "rspec-sidekiq", "~> 3.1", require: false
  gem "simplecov", "~> 0.20.0"
  gem "simplecov-cobertura", "~> 1.4.2"
  gem "simplecov-console", "~> 0.8.0"
  gem "simplecov-lcov", "~> 0.8.0"
  gem "webmock", "~> 3.10"
end

group :development do
  gem "semver2", "~> 3.4", require: false
  gem "solargraph", "~> 0.39.17", require: false
  gem "spring", "~> 2.1.1", require: false
end
