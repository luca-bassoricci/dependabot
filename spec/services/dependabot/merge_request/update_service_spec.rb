# frozen_string_literal: true

describe Dependabot::MergeRequest::UpdateService, epic: :services, feature: :dependabot, integration: true do
  include_context "with dependabot helper"
  include_context "with webmock"

  let(:gitlab) { instance_double("Gitlab::client", project: Gitlab::ObjectifiedHash.new(default_branch: branch)) }
  let(:updated_dependency) { instance_double("Dependabot::UpdatedDependency", updated_files: updated_files) }

  let(:branch) { "master" }
  let(:project) { Project.new(name: repo) }
  let(:config) { dependabot_config.first }

  let(:mr) do
    MergeRequest.new(
      project: project,
      iid: 1,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      main_dependency: "rspec"
    )
  end

  before do
    stub_gitlab

    allow(Gitlab).to receive(:client) { gitlab }
    allow(Gitlab::Config::Fetcher).to receive(:call).with(repo, branch) { raw_config }
    allow(Dependabot::FileFetcher).to receive(:call).with(repo, config, nil) { fetcher }
    allow(Dependabot::DependencyUpdater).to receive(:call)
      .with(
        project_name: repo,
        config: config,
        fetcher: fetcher,
        name: "rspec",
        repo_contents_path: nil
      )
      .and_return(updated_dependency)

    allow(Gitlab::MergeRequest::Updater).to receive(:call)

    project.save!
    mr.save!
  end

  it "updates merge request" do
    described_class.call(project_name: repo, mr_iid: mr.iid)

    expect(Gitlab::MergeRequest::Updater).to have_received(:call).with(
      fetcher: fetcher,
      updated_files: updated_files,
      merge_request: mr,
      target_project_id: nil,
      recreate: true
    )
  end
end
