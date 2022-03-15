# frozen_string_literal: true

describe Dependabot::MergeRequest::UpdateService, epic: :services, feature: :dependabot, integration: true do
  subject(:update) { described_class.call(project_name: repo, mr_iid: mr.iid, recreate: recreate) }

  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::Client", merge_request: gitlab_mr, rebase_merge_request: nil) }
  let(:fetcher) { instance_double("Dependabot::FileFetcher", files: "files", source: "source", commit: "commit") }
  let(:pr_updater) { instance_double("Dependabot::PullRequestUpdater", update: nil) }

  let(:conflicts) { false }
  let(:recreate) { false }

  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:config) { dependabot_config.first }
  let(:update_to_versions) { updated_dependency.current_versions }
  let(:gitlab_mr) { Gitlab::ObjectifiedHash.new(iid: mr.iid, state: state, web_url: "url", has_conflicts: conflicts) }
  let(:dependencies) { [instance_double("Dependabot::Dependency", name: "config")] }
  let(:state) { "opened" }
  let(:dependency_state) { Dependabot::Dependencies::UpdateChecker::HAS_UPDATES }
  let(:branch) { "update-branch" }

  let(:mr) do
    MergeRequest.new(
      project: project,
      iid: 1,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      main_dependency: "config",
      commit_message: "original-commit",
      update_to: update_to_versions,
      branch: branch
    )
  end

  let(:updated_dependency) do
    Dependabot::Dependencies::UpdatedDependency.new(
      name: "config",
      state: dependency_state,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      vulnerable: false,
      security_advisories: [],
      auto_merge_rules: []
    )
  end

  let(:updater_args) do
    {
      credentials: Dependabot::Credentials.call,
      source: fetcher.source,
      base_commit: fetcher.commit,
      old_commit: mr.commit_message,
      pull_request_number: mr.iid,
      files: updated_dependency.updated_files,
      provider_metadata: { target_project_id: nil }
    }
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

    allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
      .with(
        dependency: dependencies[0],
        dependency_files: fetcher.files,
        config: config,
        repo_contents_path: nil
      )
      .and_return(updated_dependency)

    allow(Dependabot::PullRequestUpdater).to receive(:new).with(**updater_args) { pr_updater }

    project.save!
    mr.save!
  end

  context "with successfull update", :aggregate_failures do
    context "without recreate and conflicts" do
      it "rebases merge request" do
        update

        expect(gitlab).to have_received(:rebase_merge_request).with(repo, mr.iid)
        expect(pr_updater).not_to have_received(:update)
      end
    end

    context "with recreate merge request option" do
      let(:recreate) { true }

      it "recreates merge request" do
        update

        expect(pr_updater).to have_received(:update)
        expect(gitlab).not_to have_received(:rebase_merge_request)
      end
    end

    context "with merge request conflicts" do
      let(:recreate) { false }
      let(:conflicts) { true }

      it "recreates merge request" do
        update

        expect(pr_updater).to have_received(:update)
        expect(gitlab).not_to have_received(:rebase_merge_request)
      end
    end
  end

  context "with unsuccessfull update" do
    let(:conflicts) { true }

    context "without updated dependency" do
      let(:dependency_state) { Dependabot::Dependencies::UpdateChecker::UPDATE_IMPOSSIBLE }

      it "raises unable to update error" do
        expect { update }.to raise_error("Dependency update is impossible!")
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

        expect(pr_updater).not_to have_received(:update)
      end
    end

    context "with dependency already up to date" do
      let(:dependency_state) { Dependabot::Dependencies::UpdateChecker::UP_TO_DATE }

      before do
        allow(Gitlab::BranchRemover).to receive(:call)
      end

      it "closes existing merge request" do
        update

        expect(Gitlab::BranchRemover).to have_received(:call).with(repo, branch)
        expect(mr.reload.state).to eq("closed")
      end
    end
  end
end
