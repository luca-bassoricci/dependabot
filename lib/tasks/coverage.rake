# frozen_string_literal: true

desc "Generate coverage from resultset.json"
task coverage: :environment do
  require "simplecov"
  require "simplecov-console"

  SimpleCov.collate(Dir["coverage/.resultset.json"], "rails") do
    formatter SimpleCov::Formatter::Console
  end
end
