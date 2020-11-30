# frozen_string_literal: true

require "simplecov"
require "simplecov-console"
require "simplecov-cobertura"
require "simplecov-lcov"

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.order = :random
end

return unless ENV["COVERAGE"]

formatters = [SimpleCov::Formatter::Console]
formatters << SimpleCov::Formatter::HTMLFormatter if ENV["COV_HTML_REPORT"]

if ENV["CI"]
  SimpleCov::Formatter::Console.max_rows = 8
  SimpleCov::Formatter::Console.output_style = "block"
  SimpleCov::Formatter::LcovFormatter.config do |conf|
    conf.report_with_single_file = true
    conf.output_directory = "coverage"
  end

  formatters << SimpleCov::Formatter::CoberturaFormatter
  formatters << SimpleCov::Formatter::LcovFormatter
end

SimpleCov.start("rails") do
  formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
  enable_coverage :branch
  add_filter "/lib/"
end
