# frozen_string_literal: true

describe DependencyUpdater do
  include_context "dependabot"
  include_context "webmock"

  before do
    stub_gitlab

    allow(Gitlab::ConfigFetcher).to receive(:call) { raw_config }
    allow(Dependabot::DependabotSource).to receive(:call) { source }
    allow(Dependabot::FileFetcher).to receive(:call) { fetcher }
    allow(Dependabot::DependencyFetcher).to receive(:call) { [dependency] }
    allow(Dependabot::MergeRequestService).to receive(:call) { "" }
  end

  it "runs dependency update for repository" do
    DependencyUpdater.call({ "repo" => repo, "package_manager" => package_manager })

    expect(Dependabot::MergeRequestService).to have_received(:call).once.with(
      fetcher: fetcher,
      dependency: dependency,
      **dependabot_config[package_manager]
    )
  end
end
