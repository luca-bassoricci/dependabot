# frozen_string_literal: true

# rubocop:disable Rails/RakeEnvironment
namespace :coverage do
  desc "Merge coverage report from multiple files"
  task :merge do
    require "simplecov"

    SimpleCov.collate Dir["reports/coverage/*/.resultset.json"]
  end
end
# rubocop:enable Rails/RakeEnvironment
