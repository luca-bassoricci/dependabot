# frozen_string_literal: true

require "gitlab"
require "semver"
require "git"

require_relative "../task_helpers/release_helpers"
require_relative "../task_helpers/chart_release_helper"
require_relative "../task_helpers/standalone_release_helper"

# rubocop:disable Rails/RakeEnvironment

namespace :release do
  desc "create new release tag"
  task(:app, [:version]) do |_task, args|
    ReleaseCreator.call(args[:version])
  end

  desc "update helm chart version"
  task(:chart, [:version]) do |_task, args|
    ChartReleaseHelper.call(args[:version])
  end

  desc "update standalone version"
  task(:standalone, [:version]) do |_task, args|
    StandaloneReleaseHelper.call(args[:version])
  end
end
# rubocop:enable Rails/RakeEnvironment
