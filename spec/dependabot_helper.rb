# frozen_string_literal: true

RSpec.shared_context("dependabot") do
  let(:package_manager) { "bundler" }
  let(:raw_config) { File.read("spec/fixture/dependabot.yml") }

  let(:source) do
    Dependabot::Source.new(
      provider: "gitlab",
      hostname: Settings.gitlab_hostname,
      api_endpoint: "https://#{Settings.gitlab_hostname}/api/v4",
      repo: "test-repo",
      directory: "/",
      branch: "master"
    )
  end

  let(:fetcher) do
    Dependabot::FileFetchers.for_package_manager(package_manager).new(
      source: source,
      credentials: Credentials.call
    )
  end

  let(:dependency) do
    Dependabot::Dependency.new(
      name: "config",
      package_manager: package_manager,
      version: "2.1.0",
      requirements: [requirement: "~> 2.1.0", groups: [:default], source: nil, file: "Gemfile"]
    )
  end

  let(:updated_dependencies) do
    requirement = dependency.requirements.first
    updated_dep = Dependabot::Dependency.new(
      name: dependency.name,
      package_manager: dependency.package_manager,
      previous_requirements: [requirement],
      previous_version: dependency.version,
      version: "2.2.1",
      requirements: [requirement.merge({ requirement: "~> 2.2.1" })]
    )
    [updated_dep]
  end

  let(:dependabot_config) do
    {
      "bundler" => {
        directory: "/",
        branch: "master",
        cron: "00 02 * * sun",
        milestone: 4,
        custom_labels: ["dependency"],
        branch_name_separator: "-",
        assignees: ["andrcuns"],
        reviewers: ["andrcuns"],
        commit_message_options: {
          prefix: "dep",
          prefix_development: "bundler-dev",
          include_scope: "scope"
        }
      }
    }
  end
end
