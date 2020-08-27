# frozen_string_literal: true

# Common objects and constants used in most specs
RSpec.shared_context("dependabot") do
  let(:repo) { "test-repo" }
  let(:package_manager) { "bundler" }
  let(:raw_config) { File.read("spec/gitlab_mock/responses/gitlab/dependabot.yml") }
  let(:allow_conf) { [{ dependency_type: "direct" }] }
  let(:ignore_conf) { [{ dependency_name: "rspec", versions: ["3.x", "4.x"] }] }

  let(:source) do
    Dependabot::Source.new(
      provider: "gitlab",
      hostname: URI(Settings.gitlab_url),
      api_endpoint: "#{Settings.gitlab_url}/api/v4",
      repo: "test-repo",
      directory: "/",
      branch: "master"
    )
  end

  let(:fetcher) do
    Dependabot::FileFetchers.for_package_manager(package_manager).new(
      source: source,
      credentials: Credentials.fetch
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

  let(:updated_files) do
    [
      Dependabot::DependencyFile.new(
        name: "Gemfile",
        directory: "./",
        content: ""
      ),
      Dependabot::DependencyFile.new(
        name: "Gemfile.lock",
        directory: "./",
        content: ""
      )
    ]
  end

  # Parsed version of spec/gitlab_mock/responses/gitlab/dependabot.yml
  let(:dependabot_config) do
    [
      {
        package_manager: "bundler",
        directory: "/",
        milestone: 4,
        assignees: ["andrcuns"],
        reviewers: ["andrcuns"],
        custom_labels: ["dependency"],
        open_merge_requests_limit: 10,
        cron: "00 02 * * sun Europe/Riga",
        branch_name_separator: "-",
        branch_name_prefix: "dependabot",
        commit_message_options: {
          prefix: "dep",
          prefix_development: "bundler-dev",
          include_scope: "scope"
        },
        allow: allow_conf,
        ignore: ignore_conf
      }
    ]
  end
end
