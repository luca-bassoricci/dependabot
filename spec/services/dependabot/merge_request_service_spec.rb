# frozen_string_literal: true

describe Dependabot::MergeRequestService do
  include_context "webmock"
  include_context "dependabot"

  let(:pr_creator) { double("PullRequestCreator", create: "mr") }
  let(:pr_updater) { double("PullRequestUpdater", update: "mr") }
  let(:mr) { OpenStruct.new(web_url: "mr-url") }
  let(:updated_files) do
    [
      Dependabot::DependencyFile.new(
        name: "Gemfile",
        directory: "./",
        content: ""
      ),
      Dependabot::DependencyFile.new(
        name: "Gemfile.lock",
        directory: "./",
        content: ""
      )
    ]
  end
  let(:mr_params) do
    {
      milestone: 4,
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

  subject do
    Dependabot::MergeRequestService.call(
      fetcher: fetcher,
      dependency: dependency,
      **dependabot_config[package_manager]
    )
  end

  before do
    stub_gitlab

    stub_request(:get, %r{#{repo_url}/merge_requests}).to_return(mr_get_return)

    allow(Dependabot::UpdateChecker).to receive(:call)
      .with(dependency: dependency, dependency_files: fetcher.files, ignore: ignore_conf)
      .and_return(updated_dependencies)
    allow(Dependabot::FileUpdater).to receive(:call)
      .with(dependencies: updated_dependencies, dependency_files: fetcher.files, package_manager: package_manager)
      .and_return(updated_files)

    allow(Dependabot::PullRequestCreator).to receive(:new) { pr_creator }
    allow(Dependabot::PullRequestUpdater).to receive(:new) { pr_updater }
  end

  context "merge request" do
    let(:mr_get_return) { { status: 200, body: [].to_json } }

    it "is created" do
      expect(subject).to eq("mr")
      expect(Dependabot::PullRequestCreator).to have_received(:new).with(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.fetch,
        label_language: true,
        **mr_params,
        assignees: [10],
        reviewers: { approvers: [10] }
      )
    end
  end

  context "merge request" do
    let(:mr_get_return) { { status: 200, body: [{ iid: 1, sha: "5f92cc4d9939", has_conflicts: true }].to_json } }
    it "is updated" do
      expect(subject).to eq("mr")
      expect(Dependabot::PullRequestUpdater).to have_received(:new).with(
        source: fetcher.source,
        base_commit: fetcher.commit,
        old_commit: "5f92cc4d9939",
        files: updated_files,
        credentials: Credentials.fetch,
        pull_request_number: 1
      )
    end
  end
end
