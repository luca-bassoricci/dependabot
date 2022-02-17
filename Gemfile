# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 2.6"

gem "anyway_config", "~> 2.2"
gem "bootsnap", ">= 1.4.2", require: false
gem "dependabot-omnibus", "~> 0.173.0"
gem "dry-validation", "~> 1.8"
gem "gitlab", github: "narkoz/gitlab"
gem "lograge", "~> 0.11.2"
gem "mongoid", "~> 7.3"
gem "mongoid_rails_migrations", "~> 1.4"
gem "puma", "~> 5.6"
gem "rails", "~> 6.1.4"
gem "rails-healthcheck", "~> 1.4"
gem "semantic_range", "~> 3.0"
gem "sentry-rails", "~> 5.1", require: false
gem "sentry-ruby", "~> 5.1", require: false
gem "sentry-sidekiq", "~> 5.1", require: false
gem "sidekiq", "~> 6.4.1"
gem "sidekiq_alive", "~> 2.1", require: false
gem "sidekiq-cron", "~> 1.2"
gem "yabeda-prometheus-mmap", "~> 0.3.0"
gem "yabeda-puma-plugin", "~> 0.6.0"
gem "yabeda-sidekiq", "~> 0.8.1"

group :development, :test do
  gem "pry-byebug", "~> 3.9"
  gem "pry-rails", "~> 0.3.9"
  gem "reek", "~> 6.1", require: false
  gem "rubocop", "~> 1.25.1", require: false
  gem "rubocop-performance", "~> 1.13.2", require: false
  gem "rubocop-rails", "~> 2.13", require: false
  gem "rubocop-rspec", "~> 2.8", require: false
end

group :test do
  gem "airborne", "~> 0.3.7"
  gem "allure-rspec", "~> 2.16.1"
  gem "faker", "~> 2.19"
  gem "rails-controller-testing", "~> 1.0"
  gem "rspec", "~> 3.11"
  gem "rspec_junit_formatter", "~> 0.5.1"
  gem "rspec-rails", "~> 5.1.0"
  gem "rspec-sidekiq", "~> 3.1", require: false
  gem "simplecov", "~> 0.21.2", require: false
  gem "simplecov-cobertura", "~> 2.1.0"
  gem "simplecov-console", "~> 0.9.1"
  gem "webmock", "~> 3.14"
end

group :development do
  gem "git", "~> 1.10", require: false
  gem "semver2", "~> 3.4", require: false
  gem "solargraph", "~> 0.44.3", require: false
  gem "spring", "~> 4.0.0", require: false
  gem "spring-commands-rspec", "~> 1.0.4"
end
