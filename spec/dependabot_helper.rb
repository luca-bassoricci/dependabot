# frozen_string_literal: true

# Common objects and constants used in most specs
RSpec.shared_context("with dependabot helper") do
  let(:repo) { Faker::Alphanumeric.unique.alpha(number: 15) }
  let(:package_manager) { "bundler" }
  let(:raw_config) { File.read("spec/fixture/gitlab/responses/dependabot.yml") }
  let(:allow_conf) { [{ dependency_type: "direct" }] }
  let(:ignore_conf) do
    [
      { dependency_name: "rspec", versions: ["3.x", "4.x"] },
      { dependency_name: "faker", update_types: ["version-update:semver-major"] }
    ]
  end

  let(:source) do
    Dependabot::Source.new(
      provider: "gitlab",
      hostname: URI(AppConfig.gitlab_url),
      api_endpoint: "#{AppConfig.gitlab_url}/api/v4",
      repo: repo,
      directory: "/",
      branch: "master"
    )
  end

  let(:fetcher) do
    Dependabot::FileFetchers.for_package_manager(package_manager).new(
      source: source,
      credentials: Dependabot::Credentials.call
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
        package_ecosystem: "bundler",
        directory: "/",
        milestone: "0.0.1",
        assignees: ["john_doe"],
        reviewers: ["john_smith"],
        approvers: ["jane_smith"],
        custom_labels: ["dependency"],
        open_merge_requests_limit: 10,
        cron: "00 02 * * sun Europe/Riga",
        branch_name_separator: "-",
        branch_name_prefix: "dependabot",
        allow: allow_conf,
        ignore: ignore_conf,
        rebase_strategy: "auto",
        auto_merge: true,
        versioning_strategy: :lockfile_only,
        reject_external_code: true,
        commit_message_options: {
          prefix: "dep",
          prefix_development: "bundler-dev",
          include_scope: "scope",
          trailers: {
            changelog: "dep"
          }
        },
        registries: [
          {
            "type" => "docker_registry",
            "registry" => "registry.hub.docker.com",
            "username" => "octocat",
            "password" => "password"
          }
        ]
      }
    ]
  end
end
