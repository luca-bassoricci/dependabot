# frozen_string_literal: true

require_relative "../task_helpers/release_helpers"
require_relative "../task_helpers/chart_release_helper"
require_relative "../task_helpers/standalone_release_helper"

namespace :release do
  desc "create new release tag and update changelog"
  task(:app, [:version] => :environment) do |_task, args|
    ReleaseCreator.call(args[:version])
  end

  desc "create new gitlab release"
  task(:gitlab, [:version] => :environment) do |_task, args|
    GitlabReleaseCreator.call(args[:version])
  end

  desc "update helm chart version"
  task(:chart, [:version] => :environment) do |_task, args|
    ChartReleaseHelper.call(args[:version])
  end

  desc "update standalone version"
  task(:standalone, [:version] => :environment) do |_task, args|
    StandaloneReleaseHelper.call(args[:version])
  end
end
