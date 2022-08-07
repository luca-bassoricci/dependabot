# frozen_string_literal: true

require_relative "../task_helpers/full_container_scan"

# rubocop:disable Rails/RakeEnvironment
namespace :ci do
  desc "Merge coverage report from multiple files"
  task :merge_coverage do
    require "simplecov"

    SimpleCov.collate Dir["reports/coverage/*/.resultset.json"]
  end

  desc "Run full snyk container vulnerability scan"
  task :container_scan, [:app_image] => :environment do |_, args|
    FullContainerScan.new(args[:app_image] || ENV["APP_IMAGE"]).run
  end
end
# rubocop:enable Rails/RakeEnvironment
