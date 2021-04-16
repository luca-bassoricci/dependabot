# frozen_string_literal: true

describe Dependabot::MergeRequestService, integration: true, epic: :services, feature: :dependabot do
  include_context "with dependabot helper"

  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:config) { dependabot_config.first }
  let(:current_dependencies_name) { updated_dependencies.map { |dep| "#{dep.name}-#{dep.previous_version}" }.join("/") }
  let(:has_conflicts) { true }
  let(:mr) do
    OpenStruct.new(
      web_url: "mr-url",
      iid: Faker::Number.unique.number(digits: 10),
      sha: "5f92cc4d9939",
      has_conflicts: has_conflicts,
      references: OpenStruct.new(short: "!1")
    )
  end
  let(:existing_mr) { mr }
  let(:mr_db) { create_mr(mr.iid, "opened", current_dependencies_name) }

  def create_mr(iid, state, dependencies)
    MergeRequest.new(
      project: project,
      iid: iid,
      package_manager: config[:package_manager],
      directory: config[:directory],
      state: state,
      auto_merge: config[:auto_merge],
      dependencies: dependencies
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
    allow(Gitlab::MergeRequest::Finder).to receive(:call) { existing_mr }
    allow(Gitlab::MergeRequest::Creator).to receive(:call) { mr }
    allow(Gitlab::MergeRequest::Acceptor).to receive(:call).with(repo, mr.iid, merge_when_pipeline_succeeds: true)
    allow(Gitlab::MergeRequest::Closer).to receive(:call)
    allow(Gitlab::MergeRequest::Updater).to receive(:call)
    allow(Gitlab::MergeRequest::Commenter).to receive(:call)

    project.save!
  end

  context "with new merge request" do
    let(:existing_mr) { nil }

    before do
      allow(AppConfig).to receive(:standalone).and_return(true)
    end

    it "gets created" do
      aggregate_failures do
        expect(service_return).to eq(mr)
        expect(mr_db.dependencies).to eq(MergeRequest.find_by(iid: mr.iid).dependencies)
        expect(Gitlab::MergeRequest::Creator).to have_received(:call).with(
          fetcher: fetcher,
          updated_dependencies: updated_dependencies,
          updated_files: updated_files,
          config: dependabot_config.first
        )
      end
    end

    it "gets auto merged in standalone mode" do
      service_return

      expect(Gitlab::MergeRequest::Acceptor).to have_received(:call).with(
        repo,
        mr.iid,
        merge_when_pipeline_succeeds: true
      )
    end
  end

  context "with existing merge request" do
    it "gets updated" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Updater).to have_received(:call).with(
        fetcher: fetcher,
        updated_files: updated_files,
        merge_request: mr
      )
      expect(Gitlab::MergeRequest::Finder).to have_received(:call).with(
        project: repo,
        source_branch: "dependabot-bundler-.-master-config-2.2.1",
        target_branch: "master",
        state: "opened"
      )
    end
  end

  context "with conflicts" do
    let(:has_conflicts) { true }

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

  context "without auto_merge" do
    before do
      dependabot_config.first[:auto_merge] = false
    end

    it "merge request is not set to be merged automatically" do
      expect(service_return).to eq(mr)
      expect(Gitlab::MergeRequest::Acceptor).not_to have_received(:call)
    end
  end

  context "with newer merge request" do
    let(:existing_mr) { nil }
    let(:superseeded_mr) { create_mr(Faker::Number.unique.number(digits: 10), "opened", current_dependencies_name) }

    before do
      create_mr(Faker::Number.unique.number(digits: 10), "closed", current_dependencies_name).save!
      create_mr(Faker::Number.unique.number(digits: 10), "opened", "test1").save!
      superseeded_mr.save!
    end

    it "old mr is closed" do
      aggregate_failures do
        expect(service_return).to eq(mr)
        expect(Gitlab::MergeRequest::Closer).to have_received(:call).with(project.name, superseeded_mr.iid).once
        expect(superseeded_mr.reload.state).to eq("closed")
        expect(Gitlab::MergeRequest::Commenter).to have_received(:call).with(
          project.name,
          superseeded_mr.iid,
          "This merge request has been superseeded by #{mr.web_url}"
        ).once
      end
    end
  end
end
