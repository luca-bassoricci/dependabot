# frozen_string_literal: true

describe Dependabot::MergeRequestService do
  include_context "dependabot"

  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:users) { [10] }
  let(:current_dependencies_name) { updated_dependencies.map { |dep| "#{dep.name}-#{dep.previous_version}" }.join("/") }
  let(:existing_mr) { mr }
  let(:mr_db) { create_mr(mr.iid, "opened", current_dependencies_name) }
  let(:mr) do
    OpenStruct.new(
      web_url: "mr-url",
      iid: Faker::Number.unique.number(digits: 10),
      sha: "5f92cc4d9939",
      has_conflicts: true
    )
  end
  let(:mr_params) do
    {
      milestone: "0.0.1",
      custom_labels: ["dependency"],
      branch_name_separator: "-",
      assignees: ["andrcuns"],
      reviewers: ["andrcuns"],
      branch_name_prefix: "dependabot",
      commit_message_options: {
        prefix: "dep",
        prefix_development: "bundler-dev",
        include_scope: "scope"
      }
    }
  end

  def create_mr(iid, state, dependencies)
    MergeRequest.new(
      project: project,
      iid: iid,
      package_manager: dependabot_config.first[:package_manager],
      state: state,
      auto_merge: dependabot_config.first[:auto_merge],
      dependencies: dependencies
    )
  end

  subject do
    described_class.call(
      project: project,
      fetcher: fetcher,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      **dependabot_config.first
    )
  end

  before do
    allow(Gitlab::MergeRequestFinder).to receive(:call) { existing_mr }
    allow(Gitlab::UserFinder).to receive(:call).with(mr_params[:assignees]) { users }
    allow(Gitlab::MergeRequestCreator).to receive(:call) { mr }
    allow(Gitlab::MergeRequestUpdater).to receive(:call)
    allow(Gitlab::MergeRequestAcceptor).to receive(:call).with(mr)
    allow(Gitlab::MergeRequestCloser).to receive(:call)

    project.save!
  end

  context "new merge request" do
    let(:existing_mr) { nil }

    it "is created" do
      expect(subject).to eq(mr)
      expect(Gitlab::MergeRequestCreator).to have_received(:call).with(
        fetcher: fetcher,
        updated_dependencies: updated_dependencies,
        updated_files: updated_files,
        mr_options: {
          **mr_params,
          label_language: true,
          assignees: users,
          reviewers: { approvers: users }
        }
      )
      expect(mr_db.dependencies).to eq(MergeRequest.find_by(iid: mr.iid).dependencies)
    end
  end

  context "existing merge request" do
    it "is updated" do
      expect(subject).to eq(mr)
      expect(Gitlab::MergeRequestUpdater).to have_received(:call).with(
        fetcher: fetcher,
        updated_files: updated_files,
        merge_request: mr
      )
    end
  end

  context "merge request" do
    before do
      dependabot_config.first[:auto_merge] = false
    end

    it "is not set to be merged automatically" do
      expect(subject).to eq(mr)
      expect(Gitlab::MergeRequestAcceptor).to_not have_received(:call)
    end
  end

  context "superseeded merge requests" do
    let(:existing_mr) { nil }
    let(:superseeded_mr) { create_mr(Faker::Number.unique.number(digits: 10), "opened", current_dependencies_name) }

    before do
      create_mr(Faker::Number.unique.number(digits: 10), "closed", current_dependencies_name).save!
      create_mr(Faker::Number.unique.number(digits: 10), "opened", "test1").save!
      superseeded_mr.save!
    end

    it "are closed" do
      expect(subject).to eq(mr)
      expect(Gitlab::MergeRequestCloser).to have_received(:call).with(project.name, superseeded_mr.iid).once
      expect(superseeded_mr.reload.state).to eq("closed")
    end
  end
end
