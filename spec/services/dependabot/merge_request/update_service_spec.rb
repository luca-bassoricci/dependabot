# frozen_string_literal: true

describe Dependabot::MergeRequest::UpdateService, epic: :services, feature: :dependabot, integration: true do
  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::Client", merge_request: gitlab_mr) }
  let(:updated_dependency) { instance_double("Dependabot::UpdatedDependency", updated_files: updated_files) }

  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:config) { dependabot_config.first }

  let(:gitlab_mr) do
    Gitlab::ObjectifiedHash.new(
      iid: mr.iid
    )
  end

  let(:mr) do
    MergeRequest.new(
      project: project,
      iid: 1,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      main_dependency: "rspec",
      commit_message: "original-commit"
    )
  end

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(Dependabot::Files::Fetcher).to receive(:call).with(repo, config, nil) { fetcher }
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

    expect(gitlab).to have_received(:merge_request).with(repo, mr.iid)
    expect(Gitlab::MergeRequest::Updater).to have_received(:call).with(
      fetcher: fetcher,
      updated_files: updated_files,
      merge_request: gitlab_mr.to_hash.merge(commit_message: mr.commit_message),
      target_project_id: nil,
      recreate: true
    )
  end
end
