# frozen_string_literal: true

namespace :dependabot do
  desc "update project dependencies"
  task(:update, %i[project package_ecosystem directory] => :environment) do |_task, args|
    DependencyUpdateJob.perform_now(
      "repo" => args[:project],
      "package_ecosystem" => args[:package_ecosystem],
      "directory" => args[:directory]
    )
  end

  desc "add dependency updates for repository"
  task(:register, [:project] => :environment) do |_task, args|
    Dependabot::ProjectCreator.call(args[:project]).tap do |project|
      Scheduler::DependencyUpdateScheduler.call(project)
    end
  end
end
