# frozen_string_literal: true

describe Dependabot::MergeRequest::UpdateService, epic: :services, feature: :dependabot, integration: true do
  subject(:update) { described_class.call(project_name: repo, mr_iid: mr.iid) }

  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::Client", merge_request: gitlab_mr) }
  let(:fetcher) { instance_double("Dependabot::FileFetcher", files: "files", source: "source") }
  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:config) { dependabot_config.first }
  let(:update_to_versions) { updated_dependency.current_versions }
  let(:gitlab_mr) { Gitlab::ObjectifiedHash.new(iid: mr.iid, state: state) }
  let(:dependencies) { [instance_double("Dependabot::Dependency", name: "config")] }
  let(:state) { "opened" }

  let(:mr) do
    MergeRequest.new(
      project: project,
      iid: 1,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      main_dependency: "config",
      commit_message: "original-commit",
      update_to: update_to_versions
    )
  end

  let(:updated_dependency) do
    Dependabot::UpdatedDependency.new(
      name: "config",
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      vulnerable: false,
      security_advisories: [],
      auto_merge_rules: []
    )
  end

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(Dependabot::Files::Fetcher).to receive(:call).with(repo, config, nil) { fetcher }
    allow(Dependabot::Files::Parser).to receive(:call)
      .with(
        source: fetcher.source,
        dependency_files: fetcher.files,
        repo_contents_path: nil,
        config: config
      )
      .and_return(dependencies)

    allow(Dependabot::UpdateChecker).to receive(:call)
      .with(
        dependency: dependencies[0],
        dependency_files: fetcher.files,
        config: config,
        repo_contents_path: nil
      )
      .and_return(updated_dependency)

    allow(Gitlab::MergeRequest::Updater).to receive(:call)

    project.save!
    mr.save!
  end

  context "with successfull dependency update" do
    it "updates merge request" do
      update

      expect(Gitlab::MergeRequest::Updater).to have_received(:call).with(
        fetcher: fetcher,
        updated_files: updated_files,
        merge_request: gitlab_mr.to_hash.merge(commit_message: mr.commit_message),
        target_project_id: nil,
        recreate: true
      )
    end
  end

  context "without updated dependency" do
    before do
      allow(Dependabot::UpdateChecker).to receive(:call).and_return(nil)
    end

    it "raises unable to update error" do
      expect { update }.to raise_error("Dependency could not be updated or already up to date!")
    end
  end

  context "with newer versions to update" do
    let(:update_to_versions) { "config-2.3.0" }

    it "raises newer version exists error" do
      expect { update }.to raise_error("Newer version for update exists, new merge request will be created!")
    end
  end

  context "with merge request already merged" do
    let(:state) { "merged" }

    it "skips update" do
      update

      expect(Gitlab::MergeRequest::Updater).not_to have_received(:call)
    end
  end
end
