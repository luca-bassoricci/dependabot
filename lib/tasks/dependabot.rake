# frozen_string_literal: true

namespace :dependabot do # rubocop:disable Metrics/BlockLength
  desc "update project dependencies"
  task(:update, %i[project package_ecosystem directory] => :environment) do |_task, args|
    blank_keys = %i[project package_ecosystem directory].reject { |key| args[key] }
    raise(ArgumentError, "#{blank_keys} must not be blank") unless blank_keys.empty?

    errors = DependencyUpdateJob.perform_now(
      "project_name" => args[:project],
      "package_ecosystem" => args[:package_ecosystem],
      "directory" => args[:directory]
    )
    next if errors.empty?

    errors_string = errors.map { |it| "- #{it}" }.join("\n")
    ApplicationHelper.log(
      :error,
      "Dependency update execution failed because following errors were present:\n#{errors_string}"
    )
    exit(1)
  rescue StandardError => e
    ApplicationHelper.log(:error, "Dependency update execution failed with error: #{e}")
    exit(1)
  end

  desc "add dependency updates for repository"
  task(:register, [:projects] => :environment) do |_task, args|
    args[:projects].split(" ").each do |project_name|
      ApplicationHelper.log(:info, "Registering project '#{project_name}'")
      Dependabot::Projects::Creator.call(project_name).tap do |project|
        Cron::JobSync.call(project)
      end
    end
  end

  desc "remove dependency update for repository"
  task(:remove, [:project] => :environment) do |_task, args|
    Dependabot::Projects::Remover.call(args[:project])
  end

  desc "validate config file"
  task(:validate, [:project] => :environment) do |_task, args|
    ApplicationHelper.log(:info, "Validating config '#{DependabotConfig.config_filename}'")
    Dependabot::Config::Fetcher.call(args[:project], update_cache: true)

    ApplicationHelper.log(:info, "Configuration is valid")
  rescue Dependabot::Config::InvalidConfigurationError => e
    ApplicationHelper.log(:error, "Configuration not valid: #{e}")
    exit(1)
  end

  desc "check db connection"
  task(check_db: :environment) do
    include ApplicationHelper

    Mongo::Logger.logger = Logger.new($stdout, level: :error)

    Mongoid
      .client(:default)
      .database_names
      .present?

    log(:info, "DB connection functional!")
  rescue StandardError => e
    log(:error, e.message)
    exit(1)
  end

  desc "check redis connection"
  task(check_redis: :environment) do
    include ApplicationHelper

    Redis.new(password: ENV["REDIS_PASSWORD"], timeout: 1, reconnect_attempts: 1).tap do |redis|
      redis.ping
      redis.close
    end
    log(:info, "Redis connection functional!")
  rescue StandardError => e
    log(:error, e.message)
    exit(1)
  end

  desc "check pending migrations"
  task(check_migrations: :environment) do
    include ApplicationHelper

    migrator = Mongoid::Migrator.new(:up, ["db/migrate"])
    pending_migrations = migrator.migrations.size - migrator.migrated.size
    raise("Migrations pending!") unless pending_migrations.zero?

    log(:info, "No migrations are pending!")
  rescue StandardError => e
    log(:error, e.message)
    exit(1)
  end
end
