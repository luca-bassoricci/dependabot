# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["MOCK_URL"] ||= "localhost:8081"
ENV["SETTINGS__LOG_STDOUT"] = "false"
ENV["SETTINGS__LOG_COLOR"] = "false"
ENV["SETTINGS__LOG_LEVEL"] = "debug"
ENV["SETTINGS__PROJECT_REGISTRATION"] = "system_hook"

require_relative "support/simplecov_helper"
require_relative "support/dependabot_helper"
require_relative "support/rake_helper"
require_relative "support/system/system_helper"
require_relative "../config/environment"

require "rspec-sidekiq"
require "rspec/rails"
require "allure-rspec"

abort("The Rails environment is running in production mode!") if Rails.env.production?

RSpec.configure do |config|
  config.include Anyway::Testing::Helpers
  config.include FactoryBot::Syntax::Methods

  # Remove this line to enable support for ActiveRecord
  config.use_active_record = false

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.order = :random

  config.formatter = AllureRspecFormatter if ENV["CI"]

  config.around do |example|
    env = {
      "SETTINGS__GITLAB_ACCESS_TOKEN" => "test_token",
      "SETTINGS__DEPENDABOT_URL" => "https://dependabot-gitlab.com",
      "SETTINGS__GITLAB_URL" => ENV["GITLAB_URL"] || "http://localhost:8080",
      "DEPENDABOT_NATIVE_HELPERS_PATH" => Rails.root.join("helpers").to_s
    }

    AppConfig.instance_variable_set(:@instance, nil)
    CredentialsConfig.instance_variable_set(:@instance, nil)

    with_env(env) { example.run }
  end
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

AllureRspec.configure do |config|
  config.clean_results_directory = true
end

Airborne.configure do |config|
  config.rack_app = Rails.application
end
