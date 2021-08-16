# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 2.6"

gem "anyway_config", "~> 2.1"
gem "bootsnap", ">= 1.4.2", require: false
gem "dependabot-omnibus", "~> 0.159.1"
gem "dry-validation", "~> 1.6"
gem "gitlab", github: "narkoz/gitlab"
gem "lograge", "~> 0.11.2"
gem "mongoid", "~> 7.3"
gem "puma", "~> 5.4"
gem "rails", "~> 6.1.4"
gem "rails-healthcheck", "~> 1.4"
gem "sentry-rails", "~> 4.6", require: false
gem "sentry-ruby", "~> 4.6", require: false
gem "sentry-sidekiq", "~> 4.6", require: false
gem "sidekiq", "~> 6.2.1"
gem "sidekiq-cron", "~> 1.2"
gem "yabeda-prometheus-mmap", "~> 0.2.0"
gem "yabeda-puma-plugin", "~> 0.6.0"
gem "yabeda-sidekiq", "~> 0.8.0"

group :development, :test do
  gem "pry-byebug", "~> 3.9"
  gem "pry-rails", "~> 0.3.9"
  gem "reek", "~> 6.0", require: false
  gem "rubocop", "~> 1.19.0", require: false
  gem "rubocop-performance", "~> 1.11.4", require: false
  gem "rubocop-rails", "~> 2.11", require: false
  gem "rubocop-rspec", "~> 2.4", require: false
end

group :test do
  gem "allure-rspec", "~> 2.14.3"
  gem "faker", "~> 2.18"
  gem "rack-test", "~> 1.1"
  gem "rspec", "~> 3.10"
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "rspec-rails", "~> 5.0.2"
  gem "rspec-sidekiq", "~> 3.1", require: false
  gem "simplecov", "~> 0.21.2", require: false
  gem "simplecov-cobertura", "~> 1.4.2"
  gem "simplecov-console", "~> 0.9.1"
  gem "webmock", "~> 3.14"
end

group :development do
  gem "git", "~> 1.9", require: false
  gem "semver2", "~> 3.4", require: false
  gem "solargraph", "~> 0.43.0", require: false
  gem "spring", "~> 2.1.1", require: false
  gem "spring-commands-rspec", "~> 1.0.4"
end
