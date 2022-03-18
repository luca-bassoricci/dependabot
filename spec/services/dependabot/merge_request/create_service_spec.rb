# frozen_string_literal: true

describe Dependabot::MergeRequest::CreateService, integration: true, epic: :services, feature: :dependabot do
  include_context "with dependabot helper"
  include_context "with webmock"

  let(:gitlab) { instance_double("Gitlab::Client", rebase_merge_request: nil, accept_merge_request: nil) }
  let(:pr_updater) { instance_double("Dependabot::PullRequestUpdater", update: nil) }

  let(:mr_creator) do
    instance_double(
      "Gitlab::MergeRequest::Creator",
      branch_name: source_branch,
      commit_message: commit_message,
      call: create_mr_return
    )
  end

  let(:conflicts) { false }

  let(:project) do
    Project.new(name: repo, configuration: Configuration.new(updates: updates_config), forked_from_id: 1)
  end

  let(:source_branch) { "dependabot-bundler-.-master-config-2.2.1" }
  let(:target_branch) { "master" }
  let(:config_entry) { updates_config.first }
  let(:has_conflicts) { true }
  let(:target_project_id) { nil }
  let(:commit_message) { "update-commit" }

  let(:existing_mr) { mr }
  let(:closed_mr) { nil }
  let(:create_mr_return) { mr }

  let(:mr) do
    Gitlab::ObjectifiedHash.new(
      web_url: "mr-url",
      id: unique_id,
      iid: unique_id,
      sha: "5f92cc4d9939",
      has_conflicts: has_conflicts,
      references: { short: "!1" },
      project_id: 1
    )
  end

  let(:updated_dependency) do
    Dependabot::Dependencies::UpdatedDependency.new(
      name: dependency.name,
      state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      vulnerable: false,
      security_advisories: [],
      auto_merge_rules: auto_merge_rules
    )
  end

  let(:creator_args) do
    {
      project: project,
      fetcher: fetcher,
      updated_dependency: updated_dependency,
      config_entry: config_entry,
      target_project_id: target_project_id
    }
  end

  let(:updater_args) do
    {
      credentials: Dependabot::Credentials.call,
      source: fetcher.source,
      base_commit: fetcher.commit,
      old_commit: commit_message,
      pull_request_number: mr.iid,
      files: updated_dependency.updated_files,
      provider_metadata: { target_project_id: target_project_id }
    }
  end

  def create(recreate: false)
    described_class.call(
      project: project,
      fetcher: fetcher,
      config_entry: config_entry,
      recreate: recreate,
      updated_dependency: updated_dependency
    )
  end

  def unique_id
    Faker::Number.unique.number(digits: 10)
  end

  before do
    stub_gitlab

    allow(Gitlab).to receive(:client) { gitlab }
    allow(Gitlab::MergeRequest::Finder).to receive(:call).with(
      project: project.name,
      source_branch: source_branch,
      target_branch: fetcher.source.branch,
      state: "opened"
    ).and_return(existing_mr)
    allow(Gitlab::MergeRequest::Finder).to receive(:call).with(
      project: project.name,
      source_branch: source_branch,
      target_branch: fetcher.source.branch,
      state: "closed"
    ).and_return(closed_mr)

    allow(Gitlab::MergeRequest::Creator).to receive(:new).with(**creator_args) { mr_creator }
    allow(Dependabot::PullRequestUpdater).to receive(:new).with(**updater_args) { pr_updater }
    allow(Gitlab::MergeRequest::Commenter).to receive(:call)

    project.save!
  end

  describe "standalone", :aggregate_failures do
    let(:existing_mr) { nil }

    around do |example|
      with_env("SETTINGS__STANDALONE" => "true") { example.run }
    end

    context "with auto-merge" do
      it "creates merge request and sets to be merged automatically" do
        expect(create).to eq(mr)
        expect(mr_creator).to have_received(:call)
        expect(gitlab).to have_received(:accept_merge_request).with(
          mr.project_id,
          mr.iid,
          merge_when_pipeline_succeeds: true
        )
      end
    end

    context "without auto-merge" do
      let(:auto_merge_rules) { nil }

      it "creates merge request and doesn't set to be merged automatically" do
        expect(create).to eq(mr)
        expect(mr_creator).to have_received(:call)
        expect(gitlab).not_to have_received(:accept_merge_request)
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe "non standalone", :aggregate_failures do
    context "with new merge request" do
      let(:existing_mr) { nil }

      context "without fork" do
        it "gets created in same project" do
          expect(create).to eq(mr)
          expect(mr_creator).to have_received(:call)
          expect(gitlab).not_to have_received(:accept_merge_request)
        end
      end

      context "with fork" do
        let(:target_project_id) { 1 }

        before do
          config_entry[:fork] = true

          allow(Gitlab::MergeRequest::Finder).to receive(:call).with(
            project: target_project_id,
            source_branch: source_branch,
            target_branch: fetcher.source.branch,
            state: "closed"
          ).and_return(closed_mr)
          allow(Gitlab::MergeRequest::Finder).to receive(:call).with(
            project: target_project_id,
            source_branch: source_branch,
            target_branch: fetcher.source.branch,
            state: "opened"
          ).and_return(existing_mr)
        end

        it "gets created in forked project" do
          expect(create).to eq(mr)
          expect(mr_creator).to have_received(:call)
          expect(gitlab).not_to have_received(:accept_merge_request)
        end
      end
    end

    context "with existing merge request" do
      let(:create_mr_return) { nil }

      it "gets updated" do
        expect(create).to eq(mr)
        expect(pr_updater).to have_received(:update)
      end
    end

    context "with existing closed merge request" do
      let(:closed_mr) { mr }

      it "skips mr creation" do
        expect(create).to eq(nil)
        expect(mr_creator).not_to have_received(:call)
        expect(pr_updater).not_to have_received(:update)
        expect(gitlab).not_to have_received(:accept_merge_request)
      end
    end

    context "without conflicts and rebase strategy - none" do
      let(:create_mr_return) { nil }
      let(:has_conflicts) { false }

      before do
        config_entry[:rebase_strategy][:strategy] = "none"
      end

      it "skips updating" do
        expect(create).to eq(mr)
        expect(pr_updater).not_to have_received(:update)
      end

      it "updates on recreate flag" do
        expect(create(recreate: true)).to eq(mr)
        expect(pr_updater).to have_received(:update)
      end
    end

    context "without conflicts and rebase strategy - auto" do
      let(:create_mr_return) { nil }
      let(:has_conflicts) { false }

      before do
        config_entry[:rebase_strategy][:strategy] = "auto"
      end

      it "skips updating" do
        expect(create).to eq(mr)
        expect(pr_updater).not_to have_received(:update)
        expect(gitlab).not_to have_received(:rebase_merge_request)
      end

      it "updates on recreate flag" do
        expect(create(recreate: true)).to eq(mr)
        expect(pr_updater).to have_received(:update)
      end
    end

    context "without conflicts and rebase strategy - all" do
      let(:create_mr_return) { nil }
      let(:has_conflicts) { false }

      before do
        config_entry[:rebase_strategy][:strategy] = "all"
      end

      it "triggers merge request rebase" do
        expect(create).to eq(mr)
        expect(pr_updater).not_to have_received(:update)
        expect(gitlab).to have_received(:rebase_merge_request)
      end
    end

    context "with conflicts and rebase strategy - none" do
      let(:create_mr_return) { nil }
      let(:has_conflicts) { true }

      before do
        config_entry[:rebase_strategy][:strategy] = "none"
      end

      it "skips updating" do
        expect(create).to eq(mr)
        expect(pr_updater).not_to have_received(:update)
      end

      it "recreates on recreate flag" do
        expect(create(recreate: true)).to eq(mr)
        expect(pr_updater).to have_received(:update)
      end
    end

    context "with conflicts and rebase strategy - auto" do
      let(:create_mr_return) { nil }
      let(:has_conflicts) { true }

      before do
        config_entry[:rebase_strategy][:strategy] = "auto"
      end

      it "recreates on conflict" do
        expect(create).to eq(mr)
        expect(pr_updater).to have_received(:update)
      end

      it "recreates on recreate flag" do
        expect(create(recreate: true)).to eq(mr)
        expect(pr_updater).to have_received(:update)
      end
    end

    context "with conflicts and rebase strategy - all" do
      let(:create_mr_return) { nil }
      let(:has_conflicts) { true }

      before do
        config_entry[:rebase_strategy][:strategy] = "all"
      end

      it "recreates on conflict" do
        expect(create).to eq(mr)
        expect(pr_updater).to have_received(:update)
      end
    end

    context "with gitlab error on creation" do
      let(:response_mock) do
        Gitlab::ObjectifiedHash.new(
          code: 500,
          parsed_response: "Failure",
          request: { base_uri: "gitlab.com", path: "/merge_request" }
        )
      end

      before do
        allow(mr_creator).to receive(:call).and_raise(gitlab_error)
      end

      context "with conflict error" do
        let(:gitlab_error) { Gitlab::Error::Conflict.new(response_mock) }

        it "rescues error and performs mr update" do
          expect(create).to eq(mr)
          expect(pr_updater).to have_received(:update)
        end
      end

      context "with gitlab error and created mr" do
        let(:gitlab_error) { Gitlab::Error::NotFound.new(response_mock) }

        it "rescues error and returns mr" do
          expect(create).to eq(mr)
          expect(pr_updater).not_to have_received(:update)
        end
      end

      context "with gitlab error and not created mr" do
        let(:gitlab_error) { Gitlab::Error::ServiceUnavailable.new(response_mock) }

        before do
          allow(Gitlab::MergeRequest::Finder).to receive(:call).and_return(nil)
        end

        it "raises initial error" do
          expect { create }.to raise_error(Gitlab::Error::ServiceUnavailable)
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
