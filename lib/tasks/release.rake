# frozen_string_literal: true

require_relative "../task_helpers/release_helpers"
require_relative "../task_helpers/chart_release_helper"

namespace :dependabot do
  desc "create new release tag and update changelog"
  task(:release, [:semver] => :environment) do |_task, args|
    ReleaseCreator.call(args[:semver])
  end

  desc "create new gitlab release"
  task(:gitlab_release, [:version] => :environment) do |_task, args|
    GitlabReleaseCreator.call(args[:version])
  end

  desc "update helm chart version"
  task(:bump_chart, [:version] => :environment) do |_task, args|
    ChartReleaseHelper.call(args[:version])
  end
end
