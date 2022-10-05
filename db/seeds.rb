# frozen_string_literal: true

config = Dependabot::Config::Parser.call(<<~YAML, "test-project")
  version: 2
  registries:
    dockerhub:
      type: docker-registry
      url: registry.hub.docker.com
      username: octocat
      password: password
  updates:
    - package-ecosystem: bundler
      directory: "/"
      schedule:
        interval: weekly
YAML

project = Project.find_or_initialize_by(
  name: "test-project",
  id: 1,
  webhook_id: 1,
  forked_from_id: nil
)
project_no_config = Project.find_or_initialize_by(
  name: "test-project-no-config",
  id: 2,
  webhook_id: 1,
  forked_from_id: nil
)
project.configuration = Configuration.new(**config)

mr = MergeRequest.find_or_initialize_by(
  project: project,
  main_dependency: "rspec-retry",
  update_from: "rspec-retry-0.6.1",
  update_to: "rspec-retry-0.6.1",
  state: "opened",
  commit_message: "Update dependency",
  branch: "branch",
  auto_merge: false,
  squash: false
)

update_job = UpdateJob.new(
  project: project,
  package_ecosystem: "bundler",
  directory: "/",
  cron: "35 22 * * * UTC",
  last_executed: Time.zone.now
)

project.save!
project_no_config.save!
mr.save!
update_job.save!

update_job.save_log_entries!([{
  timestamp: Time.zone.now,
  level: "debug",
  message: "test log message"
}])
update_job.save_errors!([{
  message: "error message",
  backtrace: "error backtrace"
}])

ApplicationHelper.log(:info, "Seeded test data!")
