# frozen_string_literal: true

describe Dependabot::MergeRequestUpdater, epic: :services, feature: :dependabot, integration: true do
  include_context "with dependabot helper"
  include_context "with webmock"

  let(:gitlab) { instance_double("Gitlab::client", project: OpenStruct.new(default_branch: branch)) }
  let(:branch) { "master" }
  let(:project) { Project.new(name: repo) }
  let(:config) { dependabot_config.first }
  let(:updated_dependency) { updated_dependencies.first }
  let(:mr) do
    MergeRequest.new(
      project: project,
      iid: 1,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      main_dependency: updated_dependency.name
    )
  end

  before do
    stub_gitlab

    allow(Gitlab).to receive(:client) { gitlab }
    allow(Gitlab::Config::Fetcher).to receive(:call).with(repo, branch, update_cache: false) { raw_config }
    allow(Dependabot::FileFetcher).to receive(:call).with(repo, config, nil) { fetcher }
    allow(Dependabot::DependencyUpdater).to receive(:call)
      .with(
        project_name: repo,
        config: config,
        fetcher: fetcher,
        name: updated_dependency.name,
        repo_contents_path: nil
      )
      .and_return(updated_dependency)

    allow(Dependabot::MergeRequestService).to receive(:call)

    project.save!
    mr.save!
  end

  it "recreates merge request" do
    described_class.call(project_name: repo, mr_iid: mr.iid)

    expect(Dependabot::MergeRequestService).to have_received(:call).with(
      project: project,
      fetcher: fetcher,
      config: config,
      updated_dependency: updated_dependency,
      recreate: true
    )
  end
end
