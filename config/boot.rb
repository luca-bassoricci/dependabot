# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Custom warning processing
require "warning"

Warning.ignore(/Pattern matching is experimental/)
Warning.ignore(/Passing the timeout as a positional argument is deprecated/)
Warning.ignore(/sadd will always return an Integer in Redis 5\.0\.0/)
