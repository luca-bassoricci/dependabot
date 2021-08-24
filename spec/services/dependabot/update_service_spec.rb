# frozen_string_literal: true

describe Dependabot::UpdateService, integration: true, epic: :services, feature: :updater do
  subject(:dependency_updater) { described_class }

  include_context "with dependabot helper"
  include_context "with webmock"

  let(:gitlab) { instance_double("Gitlab::client", project: OpenStruct.new(default_branch: branch)) }
  let(:rspec) { "rspec" }
  let(:branch) { "master" }
  let(:project) { Project.new(name: repo) }
  let(:config) { dependabot_config.first }

  let(:updated_config) do
    Dependabot::UpdatedDependency.new(
      name: "config",
      updated_dependencies: ["updated_config"],
      updated_files: [],
      vulnerable: false,
      security_advisories: []
    )
  end
  let(:updated_rspec) do
    Dependabot::UpdatedDependency.new(
      name: "rspec",
      updated_dependencies: ["updated_rspec"],
      updated_files: [],
      vulnerable: true,
      security_advisories: []
    )
  end

  let(:config_mr_args) do
    {
      project: project,
      fetcher: fetcher,
      config: config,
      updated_dependency: updated_config
    }
  end
  let(:rspec_mr_args) do
    {
      project: project,
      fetcher: fetcher,
      config: config,
      updated_dependency: updated_rspec
    }
  end

  before do
    stub_gitlab

    allow(Gitlab).to receive(:client) { gitlab }
    allow(Dependabot::FileFetcher).to receive(:call).with(repo, config, nil) { fetcher }
    allow(Dependabot::ConfigFetcher).to receive(:call)
      .with(repo, find_by: { package_ecosystem: package_manager, directory: "/" })
      .and_return(config)
    allow(Dependabot::DependencyUpdater).to receive(:call)
      .with(
        project_name: repo,
        config: config,
        fetcher: fetcher,
        repo_contents_path: nil
      )
      .and_return([updated_config, updated_rspec])

    allow(Dependabot::MergeRequestService).to receive(:call)
  end

  context "with deployed version" do
    before do
      project.save!
    end

    it "runs dependency update for repository" do
      dependency_updater.call(project_name: repo, package_ecosystem: package_manager, directory: "/")

      expect(Dependabot::MergeRequestService).to have_received(:call).with(rspec_mr_args)
      expect(Dependabot::MergeRequestService).to have_received(:call).with(config_mr_args)
    end
  end

  context "with standalone version" do
    around do |example|
      with_env("SETTINGS__STANDALONE" => "true") { example.run }
    end

    it "runs dependency update for repository" do
      dependency_updater.call(project_name: repo, package_ecosystem: package_manager, directory: "/")

      expect(Dependabot::MergeRequestService).to have_received(:call)
        .with(
          hash_including({ **rspec_mr_args.slice(:fetcher, :config, :updated_dependency), project: kind_of(Project) })
        )
      expect(Dependabot::MergeRequestService).to have_received(:call)
        .with(
          hash_including({ **config_mr_args.slice(:fetcher, :config, :updated_dependency), project: kind_of(Project) })
        )
    end
  end
end
