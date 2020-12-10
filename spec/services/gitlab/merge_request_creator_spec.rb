# frozen_string_literal: true

describe Gitlab::MergeRequestCreator do
  subject(:mr_creator_return) do
    described_class.call(
      fetcher: fetcher,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      config: config
    )
  end

  include_context "with dependabot helper"
  include_context "with webmock"

  let(:pr_creator) { instance_double("Dependabot::PullRequestCreator", create: mr) }
  let(:config) { dependabot_config.first }
  let(:mr) { OpenStruct.new(web_url: "mr-url") }
  let(:users) { [10] }
  let(:mr_opt_keys) do
    %i[
      custom_labels
      commit_message_options
      branch_name_separator
      branch_name_prefix
      milestone
    ]
  end
  let(:mr_params) do
    {
      assignees: users,
      reviewers: { approvers: users },
      label_language: true,
      **config.select { |key, _value| mr_opt_keys.include?(key) }
    }
  end

  before do
    stub_gitlab

    allow(Gitlab::UserFinder).to receive(:call).with(config[:assignees]) { users }
    allow(Dependabot::PullRequestCreator).to receive(:new) { pr_creator }
  end

  it "creates merge request" do
    expect(mr_creator_return).to eq(mr)
    expect(Dependabot::PullRequestCreator).to have_received(:new).with(
      {
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.fetch,
        github_redirection_service: "github.com",
        **mr_params
      }
    )
  end
end
