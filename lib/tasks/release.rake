# frozen_string_literal: true

namespace :dependabot do
  desc "create new release tag and update changelog"
  task(:release, [:semver] => :environment) do |_task, args|
    require_relative "../task_helpers/release_helpers"

    ReleaseCreator.call(args[:semver])
  end

  desc "create new gitlab release"
  task(:gitlab_release, [:version] => :environment) do |_task, args|
    require_relative "../task_helpers/release_helpers"

    GitlabReleaseCreator.call(args[:version])
  end
end
