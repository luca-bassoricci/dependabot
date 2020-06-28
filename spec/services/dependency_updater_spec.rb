# frozen_string_literal: true

describe DependencyUpdater do
  include_context "dependabot"
  include_context "webmock"

  let(:repo) { "test-repo" }

  before do
    stub_gitlab
  end

  it "runs dependency update for repository" do
    expect(Dependabot::DependabotSource).to receive(:call)
      .with(repo: repo, branch: "master", directory: "/")
      .and_return(source)
    expect(Dependabot::FileFetcher).to receive(:call)
      .with(source: source, package_manager: package_manager)
      .and_return(fetcher)
    expect(Dependabot::DependencyFetcher).to receive(:call)
      .with(source: source, dependency_files: fetcher.files, package_manager: package_manager)
      .and_return([dependency])
    expect(Gitlab::ConfigFetcher).to receive(:call)
      .with(repo)
      .and_return(raw_config)
    expect(Configuration::Parser).to receive(:call)
      .with(raw_config)
      .and_return(dependabot_config)
    expect(Dependabot::MergeRequestCreator).to receive(:call)
      .once
      .with(fetcher: fetcher, dependency: dependency, **dependabot_config[package_manager])

    DependencyUpdater.call({ "repo" => repo, "package_manager" => package_manager })
  end
end
