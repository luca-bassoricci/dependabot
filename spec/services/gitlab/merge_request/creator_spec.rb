# frozen_string_literal: true

describe Gitlab::MergeRequest::Creator, :integration, epic: :services, feature: :gitlab do
  subject(:creator_call) do
    described_class.call(
      project: project,
      fetcher: fetcher,
      config_entry: config_entry,
      updated_dependency: updated_dependency,
      credentials: credentials,
      target_project_id: nil
    )
  end

  include_context "with dependabot helper"

  let(:config_yaml) do
    <<~YAML
      version: 2
      updates:
        - package-ecosystem: bundler
          directory: "/"
          schedule:
            interval: weekly
          assignees:
            - john_doe
          reviewers:
            - john_smith
          approvers:
            - jane_smith
          milestone: "0.0.1"
    YAML
  end

  let(:pr_creator) { instance_double("Dependabot::PullRequestCreator", gitlab_creator: gitlab_creator) }

  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:gitlab_creator) do
    instance_double(
      "Dependabot::PullRequestCreator::Gitlab",
      create: mr,
      branch_name: source_branch,
      commit_message: commit_message
    )
  end

  let(:project) { create(:project, config_yaml: config_yaml, name: project_name, forked_from_id: 1) }

  let(:credentials) { Dependabot::Credentials.call(nil) }
  let(:config_entry) { project.configuration.entry(package_ecosystem: "bundler") }
  let(:commit_message) { "commit-message" }
  let(:source_branch) { "dependabot-bundler-.-master-config-2.2.1" }
  let(:milestone_id) { 1 }
  let(:assignees) { [10] }
  let(:reviewers) { [11] }
  let(:approvers) { [12] }

  let(:mr_db) { create_mr(:build, "opened") }
  let(:mr) { Gitlab::ObjectifiedHash.new(id: mr_db.id, iid: mr_db.iid, web_url: "mr-url") }

  let(:updated_dependency) do
    Dependabot::Dependencies::UpdatedDependency.new(
      dependency: dependency,
      dependency_files: [instance_double(Dependabot::DependencyFile)],
      state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      vulnerable: false,
      auto_merge_rules: auto_merge_rules
    )
  end

  let(:mr_opt_keys) do
    %i[
      custom_labels
      branch_name_separator
      branch_name_prefix
    ]
  end

  let(:mr_params) do
    {
      assignees: assignees,
      reviewers: { reviewers: reviewers, approvers: approvers },
      milestone: milestone_id,
      label_language: true,
      commit_message_options: {},
      **config_entry.slice(*mr_opt_keys)
    }
  end

  let(:creator_args) do
    {
      source: fetcher.source,
      base_commit: fetcher.commit,
      dependencies: updated_dependencies,
      files: updated_files,
      credentials: credentials,
      github_redirection_service: "github.com",
      pr_message_footer: footer,
      provider_metadata: { target_project_id: nil },
      automerge_candidate: true,
      vulnerabilities_fixed: {},
      **mr_params
    }
  end

  let(:footer) do
    <<~MSG
      ---

      <details>
      <summary>Dependabot commands</summary>
      <br />
      You can trigger Dependabot actions by commenting on this MR

      - `#{AppConfig.commands_prefix} rebase` will rebase this MR
      - `#{AppConfig.commands_prefix} recreate` will recreate this MR rewriting all the manual changes and resolving conflicts

      </details>
    MSG
  end

  def create_mr(method, state, branch = source_branch)
    send(
      method,
      :merge_request,
      project: project,
      package_ecosystem: config_entry[:package_ecosystem],
      directory: config_entry[:directory],
      state: state,
      update_to: updated_dependency.current_versions,
      update_from: updated_dependency.previous_versions,
      branch: branch,
      target_branch: fetcher.source.branch,
      main_dependency: updated_dependency.name,
      auto_merge: updated_dependency.auto_mergeable?
    )
  end

  before do
    allow(Gitlab::UserFinder).to receive(:call).with(config_entry[:assignees]) { assignees }
    allow(Gitlab::UserFinder).to receive(:call).with(config_entry[:reviewers]) { reviewers }
    allow(Gitlab::UserFinder).to receive(:call).with(config_entry[:approvers]) { approvers }
    allow(Dependabot::PullRequestCreator).to receive(:new).with(**creator_args) { pr_creator }

    allow(Gitlab::ClientWithRetry).to receive(:current) { gitlab }
    allow(gitlab).to receive(:milestones)
      .with(project.name, title: config_entry[:milestone], include_parent_milestones: true)
      .and_return([Gitlab::ObjectifiedHash.new(id: milestone_id)])
  end

  context "without existing older mr", :aggregate_failures do
    it "creates and persists merge request" do
      expect(creator_call).to eq(mr)
      expect(MergeRequest.find_by(project: project, id: mr.id).attributes.except("_id")).to eq(
        mr_db.attributes.except("_id")
      )
    end
  end

  context "with existing older mr", :aggregate_failures do
    let(:superseded_mr) { create_mr(:build, "opened", "superseded-branch") }

    before do
      allow(Gitlab::BranchRemover).to receive(:call)
      allow(Gitlab::MergeRequest::Commenter).to receive(:call)

      create_mr(:create, "closed")
      create_mr(:create, "opened", "test1")

      superseded_mr.save!
    end

    it "closes old merge request and removes branch" do
      expect(creator_call).to eq(mr)
      expect(superseded_mr.reload.state).to eq("closed")
      expect(Gitlab::BranchRemover).to have_received(:call).with(project.name, superseded_mr.branch)
      expect(Gitlab::MergeRequest::Commenter).to have_received(:call).with(
        project.name,
        superseded_mr.iid,
        "This merge request has been superseded by #{mr.web_url}"
      ).once
    end
  end
end
