# frozen_string_literal: true

require "gitlab"
require "semver"
require "git"

require_relative "../task_helpers/release_helpers"
require_relative "../task_helpers/chart_release_helper"
require_relative "../task_helpers/standalone_release_helper"

# rubocop:disable Rails/RakeEnvironment

namespace :release do
  desc "Create new release tag"
  task(:app, %i[version dry_run]) do |_task, args|
    version = args[:version]
    release_creator = ReleaseCreator.new(version)
    next release_creator.print_changelog if args[:dry_run]

    release_creator.call
  end

  desc "Update helm chart version"
  task(:chart, [:version]) do |_task, args|
    ChartReleaseHelper.call(args[:version])
  end

  desc "Update standalone version"
  task(:standalone, [:version]) do |_task, args|
    StandaloneReleaseHelper.call(args[:version])
  end
end
# rubocop:enable Rails/RakeEnvironment
