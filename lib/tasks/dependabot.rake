# frozen_string_literal: true

namespace :dependabot do
  desc "update project dependencies"
  task(:update, %i[repo package_manager] => :environment) do |_task, args|
    DependencyUpdateJob.perform_now("repo" => args[:repo], "package_manager" => args[:package_manager])
  end

  desc "add scheduled dependency update jobs"
  task(:register, [:repo] => :environment) do |_task, args|
    repo = args[:repo]
    config_yml = Gitlab::ConfigFetcher.call(repo)
    config = Configuration::Parser.call(config_yml)

    config.each do |package_manager, opts|
      Sidekiq::Cron::Job.create(
        name: "#{repo}:#{package_manager}",
        cron: opts[:cron],
        class: "DependencyUpdateJob",
        args: { repo: repo, package_manager: package_manager },
        active_job: true,
        description: "Update #{package_manager} dependencies for #{repo} in #{opts[:directory]}"
      )
    end
  end
end
