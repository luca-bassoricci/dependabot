# frozen_string_literal: true

namespace :dependabot do # rubocop:disable Metrics/BlockLength
  desc "update project dependencies"
  task(:update, %i[project package_ecosystem directory] => :environment) do |_task, args|
    DependencyUpdateJob.perform_now(
      "repo" => args[:project],
      "package_ecosystem" => args[:package_ecosystem],
      "directory" => args[:directory]
    )
  end

  desc "add dependency updates for repository"
  task(:register, [:projects] => :environment) do |_task, args|
    args[:projects].split(" ").each do |project_name|
      ApplicationHelper.log(:info, "Registering project '#{project_name}'")
      Dependabot::ProjectCreator.call(project_name).tap do |project|
        Cron::JobSync.call(project)
      end
    end
  end

  desc "worker healthcheck"
  task(check_sidekiq: :environment) do
    ApplicationHelper.log(:debug, "Checking if sidekiq is operational.", "Healthcheck")
    Sidekiq::ProcessSet.new.size.positive? || raise("Sidekiq process is not running!")

    FileUtils.rm_f(HealthcheckConfig.filename)
    HealthcheckJob.perform_later
    sleep(0.5)
    File.exist?(HealthcheckConfig.filename) || raise("Healthcheck job failed")
  rescue StandardError => e
    ApplicationHelper.log(:error, e.message, "Healthcheck")
    exit(1)
  end
end
