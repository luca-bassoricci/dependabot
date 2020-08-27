# frozen_string_literal: true

namespace :dependabot do
  desc "update project dependencies"
  task(:update, %i[project package_manager directory] => :environment) do |_task, args|
    DependencyUpdateJob.perform_now(
      "repo" => args[:project],
      "package_manager" => args[:package_manager],
      "directory" => args[:directory]
    )
  end

  desc "add dependency updates for repository"
  task(:register, [:project] => :environment) do |_task, args|
    Scheduler::DependencyUpdateScheduler.call(args[:project])
  end
end
