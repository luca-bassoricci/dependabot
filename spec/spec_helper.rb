# frozen_string_literal: true

require "simplecov"
require "simplecov-console"
require "simplecov-cobertura"

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
  SimpleCov::Formatter::Console.output_style = "block"
  formatters << SimpleCov::Formatter::CoberturaFormatter
end

SimpleCov.start("rails") do
  enable_coverage :branch
  formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
end
