# frozen_string_literal: true

describe Dependabot::MergeRequestService do
  include_context "webmock"
  include_context "dependabot"

  let(:pr_creator) { double("PullRequestCreator") }
  let(:pr_updater) { double("PullRequestUpdater") }
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
  let(:config) do
    {
      milestone: 4,
      custom_labels: ["dependency"],
      branch_name_separator: "-",
      assignees: ["andrcuns"],
      reviewers: ["andrcuns"],
      commit_message_options: {
        prefix: "dep",
        prefix_development: "bundler-dev",
        include_scope: "scope"
      }
    }
  end

  before do
    stub_gitlab

    expect(Dependabot::UpdateChecker).to receive(:call)
      .with(dependency: dependency, dependency_files: fetcher.files)
      .and_return(updated_dependencies)
    expect(Dependabot::FileUpdater).to receive(:call)
      .with(dependencies: updated_dependencies, dependency_files: fetcher.files)
      .and_return(updated_files)
  end

  it "creates merge request" do
    stub_request(:get, %r{#{repo_url}/merge_requests})
      .to_return(status: 200, body: [].to_json)

    expect(Dependabot::PullRequestCreator).to receive(:new)
      .with(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.fetch,
        label_language: true,
        **config,
        assignees: [10],
        reviewers: { approvers: [10] }
      )
      .and_return(pr_creator)
    expect(pr_creator).to receive(:create)

    Dependabot::MergeRequestService.call(
      fetcher: fetcher,
      dependency: dependency,
      directory: "/",
      branch: "develop",
      **config
    )
  end

  it "rebases merge request" do
    stub_request(:get, %r{#{repo_url}/merge_requests})
      .to_return(status: 200, body: [{ iid: 1, sha: "5f92cc4d9939", has_conflicts: true }].to_json)

    expect(Dependabot::PullRequestUpdater).to receive(:new)
      .with(
        source: fetcher.source,
        base_commit: fetcher.commit,
        old_commit: "5f92cc4d9939",
        files: updated_files,
        credentials: Credentials.fetch,
        pull_request_number: 1
      )
      .and_return(pr_updater)
    expect(pr_updater).to receive(:update)

    Dependabot::MergeRequestService.call(
      fetcher: fetcher,
      dependency: dependency,
      directory: "/",
      branch: "develop",
      **config
    )
  end
end
