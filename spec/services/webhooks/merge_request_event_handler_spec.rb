# frozen_string_literal: true

describe Webhooks::MergeRequestEventHandler, integration: true, epic: :services, feature: :webhooks do
  include_context "with dependabot helper"

  let(:config) { dependabot_config.first }
  let(:mr_iid) { 1 }
  let(:args) { { project_name: repo, mr_iid: mr_iid, action: action } }
  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:merge_request) do
    MergeRequest.new(
      project: project,
      directory: config[:directory],
      iid: 1,
      package_ecosystem: config[:package_ecosystem],
      state: "opened",
      auto_merge: false,
      update_from: "test-0.1",
      branch: "dep-update"
    )
  end
  let(:open_merge_request) do
    MergeRequest.new(
      project: project,
      directory: config[:directory],
      iid: 3,
      package_ecosystem: config[:package_ecosystem],
      state: "opened",
      auto_merge: false,
      update_from: "test-0.1"
    )
  end
  let(:other_open_merge_request) do
    MergeRequest.new(
      project: project,
      directory: "/frontend",
      iid: 4,
      package_ecosystem: "npm",
      state: "opened",
      auto_merge: false,
      update_from: "test-0.1"
    )
  end
  let(:closed_merge_request) do
    MergeRequest.new(
      project: project,
      directory: config[:directory],
      iid: 5,
      package_ecosystem: config[:package_ecosystem],
      state: "closed",
      auto_merge: false,
      update_from: "test-0.1",
      branch: "mr-branch",
      target_branch: "master"
    )
  end
  let(:close_comment) do
    <<~TXT
      Dependabot won't notify anymore about this release, but will get in touch when a new version is available. \
      You can also ignore all major, minor, or patch releases for a dependency by adding an [`ignore` condition](https://docs.github.com/en/code-security/supply-chain-security/configuration-options-for-dependency-updates#ignore) with the desired `update_types` to your config file.
    TXT
  end

  before do
    allow(MergeRequestUpdateJob).to receive(:perform_later)

    project.save!
    merge_request.save!
  end

  context "with mr reopen action", :aggregate_failures do
    let(:gitlab) { instance_double("Gitlab::Client", create_branch: nil) }
    let(:mr_iid) { 5 }
    let(:action) { "reopen" }
    let(:mr) { closed_merge_request }

    before do
      allow(Dependabot::MergeRequest::UpdateService).to receive(:call)
      allow(Gitlab).to receive(:client) { gitlab }
      allow(gitlab).to receive(:branch).with(project.name, mr.branch).and_raise(
        Gitlab::Error::NotFound.new(
          Gitlab::ObjectifiedHash.new(
            code: 404,
            parsed_response: "Failure",
            request: { base_uri: "gitlab.com", path: "/branch" }
          )
        )
      )

      closed_merge_request.save!
    end

    it "reopens closed mr and triggers update" do
      result = described_class.call(**args)

      expect(result).to eq({ reopened_merge_request: true })
      expect(closed_merge_request.reload.state).to eq("opened")
      expect(gitlab).to have_received(:create_branch).with(project.name, mr.branch, mr.target_branch)
      expect(MergeRequestUpdateJob).to have_received(:perform_later).with(project.name, mr_iid)
    end
  end

  context "with mr close action", :aggregate_failures do
    let(:action) { "close" }

    before do
      allow(Gitlab::MergeRequest::Commenter).to receive(:call)
      allow(Gitlab::BranchRemover).to receive(:call)
    end

    it "closes saved mr, removes branch and adds a comment" do
      result = described_class.call(**args)

      expect(result).to eq({ closed_merge_request: true })
      expect(merge_request.reload.state).to eq("closed")
      expect(Gitlab::BranchRemover).to have_received(:call).with(
        project.name, merge_request.branch
      )
      expect(Gitlab::MergeRequest::Commenter).to have_received(:call).with(
        project.name, merge_request.iid, close_comment
      )
    end

    it "skips non existing mrs" do
      expect(described_class.call(**args, mr_iid: 2)).to be_nil
    end
  end

  context "with mr merge action", :aggregate_failures do
    ActiveJob::Base.queue_adapter = :test

    let(:action) { "merge" }

    before do
      open_merge_request.save!
      other_open_merge_request.save!
    end

    context "with auto-rebase enabled" do
      it "closes saved mr and triggers update of open mrs for same package_ecosystem" do
        described_class.call(**args)

        expect(MergeRequestUpdateJob).to have_received(:perform_later).with(repo, open_merge_request.iid)
        expect(merge_request.reload.state).to eq("merged")
      end
    end

    context "with auto-rebase disabled" do
      before do
        project.config.first[:rebase_strategy] = "none"
        project.save!
      end

      it "skips update for auto-rebase: none option" do
        expect(MergeRequestUpdateJob).not_to have_received(:perform_later)
      end
    end
  end
end
