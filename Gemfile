# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 2.6"

gem "config", "~> 2.2"
gem "dependabot-omnibus", "~> 0.118.13"
gem "puma", "~> 4.3"
gem "rails", "~> 6.0.3"
gem "sentry-raven", "~> 3.0", require: false
gem "sidekiq", "~> 6.1.1"
gem "sidekiq-cron", "~> 1.2"

gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "pry", "~> 0.13.1"
  gem "reek", "~> 6.0", require: false
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 0.89.1", require: false
end

group :test do
  gem "brakeman", "~> 4.9"
  gem "rack-test", "~> 1.1"
  gem "rspec", "~> 3.9"
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "rspec-sidekiq", "~> 3.1", require: false
  gem "simplecov", "~> 0.19.0"
  gem "simplecov-cobertura", "~> 1.4.0"
  gem "simplecov-console", "~> 0.7.2"
  gem "webmock", "~> 3.8"
end

group :development do
  gem "lefthook", "~> 0.7.2", require: false
  gem "solargraph", "~> 0.39.15", require: false
  gem "spring", "~> 2.1.0"
  gem "yard", "~> 0.9.25"
end
