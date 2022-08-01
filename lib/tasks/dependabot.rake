# frozen_string_literal: true

namespace :dependabot do # rubocop:disable Metrics/BlockLength
  desc "Update project dependencies"
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
    ApplicationHelper.log(:error, "Dependency update execution failed with error:")
    ApplicationHelper.log_error(e)
    exit(1)
  end

  desc "Add dependency updates for projects"
  task(:register, [:projects] => :environment) do |_task, args|
    args[:projects].split(" ").each do |project_name|
      ApplicationHelper.log(:info, "Registering project '#{project_name}'")
      Dependabot::Projects::Creator.call(project_name).tap { |project| Cron::JobSync.call(project) }
    end
  end

  desc "Register project for dependency updates with specific gitlab access token"
  task(:register_project, %i[project_name access_token] => :environment) do |_task, args|
    project_name = args[:project_name]
    access_token = args[:access_token]

    ApplicationHelper.log(:info, "Registering project '#{project_name}'")
    Dependabot::Projects::Creator.call(project_name, access_token).tap { |project| Cron::JobSync.call(project) }
  end

  desc "Run automatic project registration"
  task(automatic_registration: :environment) do
    ProjectRegistrationJob.perform_now
  end

  desc "Remove dependency updates for project"
  task(:remove, [:project] => :environment) do |_task, args|
    Dependabot::Projects::Remover.call(args[:project])
  end

  desc "Validate config file"
  task(:validate, [:project] => :environment) do |_task, args|
    ApplicationHelper.log(:info, "Validating config '#{DependabotConfig.config_filename}'")
    Dependabot::Config::Fetcher.call(args[:project], update_cache: true)

    ApplicationHelper.log(:info, "Configuration is valid")
  rescue Dependabot::Config::InvalidConfigurationError => e
    ApplicationHelper.log(:error, "Configuration not valid: #{e}")
    exit(1)
  end

  desc "Check db connection"
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

  desc "Check redis connection"
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

  desc "Check pending migrations"
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

  desc "Update GitHub GraphQL schema"
  task(update_schema: :environment) do
    GraphQL::Client.dump_schema(Github::Graphql::HTTPAdapter, "db/schema.json")
  end

  desc "Update local vulnerability database"
  task(update_vulnerability_db: :environment) do
    SecurityVulnerabilityUpdateJob.perform_now
  end
end
