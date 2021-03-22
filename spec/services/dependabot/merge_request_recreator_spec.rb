# frozen_string_literal: true

describe Dependabot::MergeRequestRecreator do
  include_context "with dependabot helper"
  include_context "with webmock"

  let(:branch) { "master" }
  let(:project) { Project.new(name: repo) }
  let(:config) { dependabot_config.first }
  let(:updated_dependency) { updated_dependencies.first }
  let(:mr) do
    MergeRequest.new(
      project: project,
      iid: 1,
      package_manager: config[:package_manager],
      directory: config[:directory],
      main_dependency: updated_dependency.name
    )
  end

  before do
    stub_gitlab

    allow(Gitlab::DefaultBranch).to receive(:call).with(repo) { branch }
    allow(Gitlab::ConfigFetcher).to receive(:call).with(repo, branch) { raw_config }
    allow(Dependabot::FileFetcher).to receive(:call).with(repo, config) { fetcher }
    allow(Dependabot::DependencyUpdater).to receive(:call)
      .with(project_name: repo, config: config, fetcher: fetcher, name: updated_dependency.name)
      .and_return(updated_dependency)

    allow(Dependabot::MergeRequestService).to receive(:call)

    project.save!
    mr.save!
  end

  it "recreates merge request" do
    described_class.call(repo, mr.iid)

    expect(Dependabot::MergeRequestService).to have_received(:call).with(
      project: project,
      fetcher: fetcher,
      config: config,
      updated_dependency: updated_dependency,
      recreate: true
    )
  end
end
