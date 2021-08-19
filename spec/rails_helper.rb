# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["SETTINGS__LOG_LEVEL"] ||= "fatal"
ENV["SETTINGS__PROJECT_REGISTRATION"] ||= "system_hook"

require_relative "simplecov_helper"
require_relative "webmock_helper"
require_relative "dependabot_helper"
require_relative "rack_helper"
require_relative "rake_helper"
require_relative "../config/environment"

require "rspec-sidekiq"
require "rspec/rails"
require "allure-rspec"
require "anyway/testing/helpers"

abort("The Rails environment is running in production mode!") if Rails.env.production?

RSpec.configure do |config|
  include Anyway::Testing::Helpers

  # Remove this line to enable support for ActiveRecord
  config.use_active_record = false

  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

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

  config.formatter = AllureRspecFormatter if ENV["GENERATE_ALLURE_REPORT"]

  config.around do |example|
    env = {
      "SETTINGS__GITLAB_ACCESS_TOKEN" => "test_token",
      "SETTINGS__DEPENDABOT_URL" => "https://dependabot-gitlab.com"
    }

    AppConfig.instance_variable_set(:@instance, nil)
    CredentialsConfig.instance_variable_set(:@instance, nil)

    with_env(env) do
      example.run
    end
  end
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

AllureRspec.configure do |config|
  config.clean_results_directory = true
end
