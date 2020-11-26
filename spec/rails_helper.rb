# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["LOG_LEVEL"] ||= "fatal"
ENV["SETTINGS__GITLAB_ACCESS_TOKEN"] ||= "token_gitlab"

require_relative "spec_helper"
require_relative "webmock_helper"
require_relative "dependabot_helper"
require_relative "rack_test_helper"
require_relative "settings_helper"
require_relative "../config/environment"

require "rspec-sidekiq"
require "rspec/rails"

abort("The Rails environment is running in production mode!") if Rails.env.production?

RSpec.configure do |config|
  # Remove this line to enable support for ActiveRecord
  config.use_active_record = false

  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

Sidekiq.logger.level = Logger::ERROR
