# frozen_string_literal: true

require "simplecov-console"
require "simplecov-cobertura"

formatters = [SimpleCov::Formatter::Console]
formatters << SimpleCov::Formatter::HTMLFormatter if ENV["COV_HTML_REPORT"]
formatters << SimpleCov::Formatter::CoberturaFormatter if ENV["CI_JOB_NAME"]&.include?("rspec")

SimpleCov.configure do
  formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
  enable_coverage :branch
  add_filter "/lib/"
end
