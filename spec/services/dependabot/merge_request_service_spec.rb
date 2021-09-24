# frozen_string_literal: true

describe Dependabot::MergeRequestService, integration: true, epic: :services, feature: :dependabot do
  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::Client", rebase_merge_request: nil, accept_merge_request: nil) }

  let(:project) { Project.new(name: repo, config: dependabot_config, forked_from_id: 1) }
  let(:source_branch) { "dependabot-bundler-.-master-config-2.2.1" }
  let(:target_branch) { "master" }
  let(:config) { dependabot_config.first }
  let(:current_dependencies_name) { updated_dependencies.map { |dep| "#{dep.name}-#{dep.previous_version}" }.join("/") }
  let(:has_conflicts) { true }
  let(:existing_mr) { mr }
  let(:closed_mr) { nil }
  let(:mr_db) { create_mr(mr.iid, "opened", current_dependencies_name) }
  let(:create_mr_return) { mr }
  let(:mr) do
    OpenStruct.new(
      web_url: "mr-url",
      id: Faker::Number.unique.number(digits: 10),
      iid: Faker::Number.unique.number(digits: 10),
      sha: "5f92cc4d9939",
      has_conflicts: has_conflicts,
      references: OpenStruct.new(short: "!1"),
      project_id: 1
    )
  end

  def create_mr(iid, state, dependencies, branch = "some-branch")
    MergeRequest.new(
      project: project,
      id: Faker::Number.unique.number(digits: 10),
      iid: iid,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      state: state,
      auto_merge: config[:auto_merge],
      dependencies: dependencies,
      branch: branch
    )
  end

  def service_return(recreate: false)
    described_class.call(
      project: project,
      fetcher: fetcher,
      config: config,
      recreate: recreate,
      updated_dependency: Dependabot::UpdatedDependency.new(
        name: dependency.name,
        updated_dependencies: updated_dependencies,
        updated_files: updated_files,
        vulnerable: false,
        security_advisories: []
      )
    )
  end

  before do
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

    allow(Gitlab::MergeRequest::Creator).to receive(:call) { create_mr_return }
    allow(Gitlab::MergeRequest::Updater).to receive(:call)
    allow(Gitlab::MergeRequest::Commenter).to receive(:call)

    project.save!
  end

  context "with new merge request" do
    let(:existing_mr) { nil }

    context "with standalone mode" do
      around do |example|
        with_env("SETTINGS__STANDALONE" => "true") { example.run }
      end

      it "mr is automerged immediatelly" do
        service_return

        expect(gitlab).to have_received(:accept_merge_request).with(
          mr.project_id,
          mr.iid,
          merge_when_pipeline_succeeds: true
        )
      end
    end

    context "without fork" do
      it "gets created in same project" do
        aggregate_failures do
          expect(service_return).to eq(mr)
          expect(Gitlab::MergeRequest::Creator).to have_received(:call).with(
            fetcher: fetcher,
            updated_dependencies: updated_dependencies,
            updated_files: updated_files,
            config: dependabot_config.first,
            target_project_id: nil
          )
          expect(gitlab).not_to have_received(:accept_merge_request)
        end
      end
    end

    context "with fork" do
      let(:target_project_id) { 1 }

      before do
        config[:fork] = true

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
        aggregate_failures do
          expect(service_return).to eq(mr)
          expect(Gitlab::MergeRequest::Creator).to have_received(:call).with(
            fetcher: fetcher,
            updated_dependencies: updated_dependencies,
            updated_files: updated_files,
            config: dependabot_config.first,
            target_project_id: target_project_id
          )
          expect(gitlab).not_to have_received(:accept_merge_request)
        end
      end
    end
  end

  context "with existing merge request" do
    let(:create_mr_return) { nil }

    it "gets updated" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call).with(
        fetcher: fetcher,
        updated_files: updated_files,
        merge_request: mr,
        target_project_id: nil
      )
    end
  end

  context "with existing closed merge request" do
    let(:closed_mr) { mr }

    it "skips mr creation" do
      aggregate_failures do
        expect(Gitlab::MergeRequest::Creator).not_to have_received(:call)
        expect(Gitlab::MergeRequest::Updater).not_to have_received(:call)
        expect(gitlab).not_to have_received(:accept_merge_request)
      end
    end
  end

  context "without conflicts and no rebase" do
    let(:create_mr_return) { nil }
    let(:has_conflicts) { false }

    before do
      config[:rebase_strategy] = "none"
    end

    it "skips updating" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).not_to have_received(:call)
    end

    it "updates on recreate flag" do
      expect(service_return(recreate: true)).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call)
    end
  end

  context "without conflicts and auto rebase - auto" do
    let(:create_mr_return) { nil }
    let(:has_conflicts) { false }

    before do
      config[:rebase_strategy] = "auto"
    end

    it "skips updating" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).not_to have_received(:call)
      expect(gitlab).not_to have_received(:rebase_merge_request)
    end

    it "updates on recreate flag" do
      expect(service_return(recreate: true)).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call)
      expect(gitlab).not_to have_received(:rebase_merge_request)
    end
  end

  context "without conflicts and auto rebase - all" do
    let(:create_mr_return) { nil }
    let(:has_conflicts) { false }

    before do
      config[:rebase_strategy] = "all"
    end

    it "triggers merge request rebase" do
      expect(service_return).to eq(mr)
      expect(gitlab).to have_received(:rebase_merge_request).with(mr.project_id, mr.iid)
      expect(Gitlab::MergeRequest::Updater).not_to have_received(:call)
    end
  end

  context "with conflicts and no rebase" do
    let(:create_mr_return) { nil }
    let(:has_conflicts) { true }

    before do
      config[:rebase_strategy] = "none"
    end

    it "skips updating" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).not_to have_received(:call)
      expect(gitlab).not_to have_received(:rebase_merge_request)
    end

    it "recreates on recreate flag" do
      expect(service_return(recreate: true)).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call)
      expect(gitlab).not_to have_received(:rebase_merge_request)
    end
  end

  context "with conflicts and auto rebase - auto" do
    let(:create_mr_return) { nil }
    let(:has_conflicts) { true }

    before do
      config[:rebase_strategy] = "auto"
    end

    it "recreates on conflict" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call)
      expect(gitlab).not_to have_received(:rebase_merge_request)
    end

    it "recreates on recreate flag" do
      expect(service_return(recreate: true)).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call)
      expect(gitlab).not_to have_received(:rebase_merge_request)
    end
  end

  context "with conflicts and auto rebase - all" do
    let(:create_mr_return) { nil }
    let(:has_conflicts) { true }

    before do
      config[:rebase_strategy] = "all"
    end

    it "recreates on conflict" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call)
      expect(gitlab).not_to have_received(:rebase_merge_request)
    end
  end

  context "without auto_merge" do
    before do
      dependabot_config.first[:auto_merge] = false
    end

    it "merge request is not set to be merged automatically" do
      expect(service_return).to eq(mr)
      expect(gitlab).not_to have_received(:accept_merge_request)
    end
  end

  context "with newer merge request" do
    let(:existing_mr) { nil }
    let(:superseeded_mr) do
      create_mr(Faker::Number.unique.number(digits: 10), "opened", current_dependencies_name, "superseeded-branch")
    end

    before do
      allow(Gitlab::BranchRemover).to receive(:call)

      create_mr(Faker::Number.unique.number(digits: 10), "closed", current_dependencies_name).save!
      create_mr(Faker::Number.unique.number(digits: 10), "opened", "test1").save!
      superseeded_mr.save!
    end

    it "old mr is closed and branch removed" do
      aggregate_failures do
        expect(service_return).to eq(mr)
        expect(Gitlab::MergeRequest::Commenter).to have_received(:call).with(
          project.name,
          superseeded_mr.iid,
          "This merge request has been superseeded by #{mr.web_url}"
        ).once
        expect(Gitlab::BranchRemover).to have_received(:call).with(project.name, superseeded_mr.branch)

        expect(superseeded_mr.reload.state).to eq("closed")
      end
    end
  end

  context "with gitlab error on creation" do
    let(:response_mock) do
      OpenStruct.new(
        code: 500,
        parsed_response: "Failure",
        request: OpenStruct.new(base_uri: "gitlab.com", path: "/merge_request")
      )
    end

    before do
      allow(Gitlab::MergeRequest::Creator).to receive(:call).and_raise(gitlab_error)
    end

    context "with conflict error" do
      let(:gitlab_error) { Gitlab::Error::Conflict.new(response_mock) }

      it "rescues error and performs mr update" do
        expect(service_return).to eq(mr)

        expect(Gitlab::MergeRequest::Updater).to have_received(:call)
      end
    end

    context "with gitlab error and created mr" do
      let(:gitlab_error) { Gitlab::Error::NotFound.new(response_mock) }

      it "rescues error and returns mr" do
        expect(service_return).to eq(mr)

        expect(Gitlab::MergeRequest::Updater).not_to have_received(:call)
      end
    end

    context "with gitlab error and not created mr" do
      let(:gitlab_error) { Gitlab::Error::ServiceUnavailable.new(response_mock) }

      before do
        allow(Gitlab::MergeRequest::Finder).to receive(:call).and_return(nil)
      end

      it "raises initial error" do
        expect { service_return }.to raise_error(Gitlab::Error::ServiceUnavailable)
      end
    end
  end
end
