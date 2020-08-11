# frozen_string_literal: true

namespace :dependabot do
  desc "update project dependencies"
  task(:update, %i[repo package_manager] => :environment) do |_task, args|
    DependencyUpdateJob.perform_now("repo" => args[:repo], "package_manager" => args[:package_manager])
  end

  desc "add dependency updates for repository"
  task(:register, [:repo] => :environment) do |_task, args|
    Scheduler::DependencyUpdateScheduler.call(args[:repo])
  end
end
