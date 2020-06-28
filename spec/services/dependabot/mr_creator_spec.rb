# frozen_string_literal: true

describe Dependabot::MergeRequestCreator do
  include_context "webmock"
  include_context "dependabot"

  let(:pr_creator) { double("PullRequestCreator") }
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
  end

  it "creates merge request" do
    expect(Dependabot::UpdateChecker).to receive(:call)
      .with(dependency: dependency, dependency_files: fetcher.files)
      .and_return(updated_dependencies)
    expect(Dependabot::FileUpdater).to receive(:call)
      .with(dependencies: updated_dependencies, dependency_files: fetcher.files)
      .and_return(updated_files)
    expect(Dependabot::PullRequestCreator).to receive(:new)
      .with(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.call,
        label_language: true,
        **config,
        assignees: [10],
        reviewers: { approvers: [10] }
      )
      .and_return(pr_creator)
    expect(pr_creator).to receive(:create).and_return(mr)

    actual_mr = Dependabot::MergeRequestCreator.call(
      fetcher: fetcher,
      dependency: dependency,
      directory: "/",
      branch: "develop",
      **config
    )

    expect(actual_mr).to eq(mr)
  end
end
