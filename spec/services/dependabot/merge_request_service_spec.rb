# frozen_string_literal: true

describe Dependabot::MergeRequestService do
  include_context "webmock"
  include_context "dependabot"

  let(:updated_dep_name) { "test 0.0.1 => 0.0.2" }
  let(:mr) { OpenStruct.new(web_url: "mr-url", project_id: 1, iid: 1, sha: "5f92cc4d9939", has_conflicts: true) }
  let(:pr_creator) { double("PullRequestCreator", create: mr) }
  let(:pr_updater) { double("PullRequestUpdater", update: mr) }
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

  subject do
    described_class.call(
      name: updated_dep_name,
      fetcher: fetcher,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      **dependabot_config.first
    )
  end

  before do
    stub_gitlab

    stub_request(:get, %r{#{repo_url}/merge_requests}).to_return(mr_get_return)

    allow(Dependabot::PullRequestCreator).to receive(:new) { pr_creator }
    allow(Dependabot::PullRequestUpdater).to receive(:new) { pr_updater }

    @accept_stub = stub_request(:put, "#{source.api_endpoint}/projects/#{mr.project_id}/merge_requests/#{mr.iid}/merge")
                   .with(body: { "merge_when_pipeline_succeeds" => "true" })
                   .to_return(status: 200, body: "")
  end

  context "merge request" do
    let(:mr_get_return) { { status: 200, body: [].to_json } }

    it "is created" do
      subject

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
      expect(pr_creator).to have_received(:create)
    end

    it "is set to merge after creation" do
      described_class.call(
        name: updated_dep_name,
        fetcher: fetcher,
        updated_dependencies: updated_dependencies,
        updated_files: updated_files,
        auto_merge: true,
        **dependabot_config.first
      )

      expect(@accept_stub).to have_been_requested
    end
  end

  context "merge request" do
    let(:mr_get_return) { { status: 200, body: [mr.to_h].to_json } }

    it "is updated" do
      subject

      expect(Dependabot::PullRequestUpdater).to have_received(:new).with(
        source: fetcher.source,
        base_commit: fetcher.commit,
        old_commit: mr.sha,
        files: updated_files,
        credentials: Credentials.fetch,
        pull_request_number: 1
      )
      expect(pr_updater).to have_received(:update)
    end

    it "is set to merge after update" do
      described_class.call(
        name: updated_dep_name,
        fetcher: fetcher,
        updated_dependencies: updated_dependencies,
        updated_files: updated_files,
        auto_merge: true,
        **dependabot_config.first
      )

      expect(@accept_stub).to have_been_requested
    end
  end

  context "merge request" do
    let(:mr_get_return) { { status: 200, body: [].to_json } }

    before do
      allow(Dependabot::PullRequestCreator).to receive(:new).and_raise(Octokit::TooManyRequests)
      allow(Rails.logger).to receive(:error)
    end

    it "is not created when github api limit is exceeded" do
      subject

      expect(Rails.logger).to have_received(:error)
    end
  end
end
