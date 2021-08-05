# frozen_string_literal: true

describe Gitlab::MergeRequest::Creator, epic: :services, feature: :gitlab do
  subject(:mr_creator_return) do
    described_class.call(
      fetcher: fetcher,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      config: config,
      target_project_id: 1
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
        credentials: Dependabot::Credentials.call,
        github_redirection_service: "github.com",
        pr_message_footer: footer,
        target_project_id: 1,
        **mr_params
      }
    )
  end
end
