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
  task(:register, [:project] => :environment) do |_task, args|
    Dependabot::ProjectCreator.call(args[:project]).tap do |project|
      Scheduler::DependencyUpdateScheduler.call(project)
    end
  end

  desc "worker healthcheck"
  task(check_sidekiq: :environment) do
    Sidekiq.configure_client do |config|
      config.redis = {
        password: ENV["REDIS_PASSWORD"],
        timeout: 1,
        reconnect_attempts: 3
      }
    end

    Rails.logger.debug { "Checking if sidekiq is operational." }
    Sidekiq::ProcessSet.new.size.positive? || raise("Sidekiq process is not running!")

    FileUtils.rm_f(Settings.sidekiq_healthcheck_filename)
    HealthcheckJob.perform_later
    sleep(0.5)
    File.exist?(Settings.sidekiq_healthcheck_filename) || raise("Healthcheck job failed")
  rescue StandardError => e
    Rails.logger.error { "[Healthcheck] #{e.message}" }
    exit(1)
  end
end
