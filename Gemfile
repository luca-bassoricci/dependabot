# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 2.6"

gem "anyway_config", "~> 2.1"
gem "bootsnap", ">= 1.4.2", require: false
gem "dependabot-omnibus", "~> 0.133.6"
gem "dry-validation", "~> 1.6"
gem "lograge", "~> 0.11.2"
gem "mongoid", "~> 7.2"
gem "puma", "~> 5.2"
gem "rails", "~> 6.1.3"
gem "rails-healthcheck", "~> 1.2"
gem "semantic_range", "~> 2.3"
gem "sentry-raven", "~> 3.1", require: false
gem "sidekiq", "~> 6.1.3"
gem "sidekiq-cron", "~> 1.2"
gem "yabeda-prometheus-mmap", "~> 0.1.1"
gem "yabeda-puma-plugin", "~> 0.6.0"
gem "yabeda-sidekiq", "~> 0.7.0"

group :development, :test do
  gem "pry-byebug", "~> 3.9"
  gem "pry-rails", "~> 0.3.9"
  gem "reek", "~> 6.0", require: false
  gem "rubocop", "~> 1.11.0", require: false
  gem "rubocop-performance", "~> 1.10.0", require: false
  gem "rubocop-rails", "~> 2.9", require: false
  gem "rubocop-rspec", "~> 2.2", require: false
end

group :test do
  gem "faker", "~> 2.16"
  gem "rack-test", "~> 1.1"
  gem "rspec", "~> 3.10"
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "rspec-rails", "~> 4.0.2"
  gem "rspec-sidekiq", "~> 3.1", require: false
  gem "simplecov", "~> 0.21.2", require: false
  gem "simplecov-cobertura", "~> 1.4.2"
  gem "simplecov-console", "~> 0.9.1"
  gem "webmock", "~> 3.12"
end

group :development do
  gem "git", "~> 1.8", require: false
  gem "semver2", "~> 3.4", require: false
  gem "solargraph", "~> 0.40.3", require: false
  gem "spring", "~> 2.1.1", require: false
end
