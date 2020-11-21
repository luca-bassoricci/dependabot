# frozen_string_literal: true

describe DependencyUpdater do
  subject(:dependency_updater) { described_class }

  include_context "dependabot"
  include_context "webmock"

  let(:config) { "config" }
  let(:rspec) { "rspec" }

  let(:project) { Project.new(name: repo) }

  let(:updated_config) do
    {
      name: "config 2.1.0 => 2.2.1",
      dependencies: ["updated_config"],
      vulnerable: false,
      security_advisories: []
    }
  end
  let(:updated_rspec) do
    {
      name: "rspec 3.8 => 3.9",
      dependencies: ["updated_rspec"],
      vulnerable: true,
      security_advisories: ["CVE"]
    }
  end

  let(:checker_args) { { dependency_files: fetcher.files, allow: allow_conf, ignore: ignore_conf } }
  let(:file_updater_args) { { dependency_files: fetcher.files, package_manager: package_manager } }
  let(:mr_service_args) do
    {
      fetcher: fetcher,
      updated_files: updated_files,
      **dependabot_config.first
    }
  end

  before do
    stub_gitlab

    allow(Gitlab::ConfigFetcher).to receive(:call) { raw_config }
    allow(Dependabot::DependabotSource).to receive(:call) { source }
    allow(Dependabot::FileFetcher).to receive(:call) { fetcher }
    allow(Dependabot::FileParser).to receive(:call) { [config, rspec] }
    allow(Dependabot::MergeRequestService).to receive(:call).and_return("")

    allow(Dependabot::UpdateChecker).to receive(:call).with(dependency: config, **checker_args) { updated_config }
    allow(Dependabot::UpdateChecker).to receive(:call).with(dependency: rspec, **checker_args) { updated_rspec }
    allow(Dependabot::FileUpdater).to receive(:call)
      .with(dependencies: updated_config[:dependencies], **file_updater_args) { updated_files }
    allow(Dependabot::FileUpdater).to receive(:call)
      .with(dependencies: updated_rspec[:dependencies], **file_updater_args) { updated_files }

    project.save!
  end

  it "runs dependency update for repository" do
    dependency_updater.call({ "repo" => repo, "package_ecosystem" => package_manager, "directory" => "/" })

    expect(Dependabot::MergeRequestService).to have_received(:call).with(
      project: project,
      updated_dependencies: updated_config[:dependencies],
      **mr_service_args
    )
    expect(Dependabot::MergeRequestService).to have_received(:call).with(
      project: project,
      updated_dependencies: updated_rspec[:dependencies],
      **mr_service_args
    )
  end
end
