# frozen_string_literal: true

describe Dependabot::DependencyUpdater, epic: :services, feature: :dependabot do
  include_context "with webmock"
  include_context "with dependabot helper"

  let(:config) { dependabot_config.first }
  let(:repo_contents_path) { nil }
  let(:updater_args) do
    {
      project_name: repo,
      config: config,
      fetcher: fetcher,
      repo_contents_path: repo_contents_path
    }
  end

  let(:result) do
    Dependabot::UpdatedDependency.new(
      name: dependency.name,
      updated_files: updated_files,
      updated_dependencies: updated_dependencies,
      vulnerable: false,
      security_advisories: [],
      auto_merge_rules: auto_merge_rules
    )
  end

  before do
    stub_gitlab

    allow(Dependabot::Files::Parser).to receive(:call)
      .with(
        source: fetcher.source,
        dependency_files: fetcher.files,
        repo_contents_path: repo_contents_path,
        config: config
      )
      .and_return([dependency])
    allow(Dependabot::UpdateChecker).to receive(:call)
      .with(
        dependency: dependency,
        dependency_files: fetcher.files,
        config: config,
        repo_contents_path: repo_contents_path
      )
      .and_return(result)
  end

  context "with vendored deps" do
    let(:repo_contents_path) do
      Rails.root.join("tmp", "repo-contents", repo, Time.zone.now.strftime("%d-%m-%Y-%H-%M-%S"))
    end

    before do
      config[:vendor] = true
    end

    it "returns updated dependencies" do
      expect(described_class.call(updater_args)).to eq([result])
    end
  end

  context "without vendored deps" do
    it "returns updated dependencies" do
      expect(described_class.call(updater_args)).to eq([result])
    end

    it "returns nil if dependency not found" do
      expect(described_class.call(**updater_args, name: "test")).to be_nil
    end

    context "without any dependencies updated" do
      let(:result) { nil }

      it "returns nil" do
        expect(described_class.call(**updater_args, name: dependency.name)).to be_nil
      end
    end
  end

  context "with single dependency" do
    let(:args) { { **updater_args, name: dependency.name } }

    it "returns single updated dependency" do
      expect(described_class.call(**args)).to eq(result)
    end

    it "returns nil if dependency not found" do
      expect(described_class.call(**updater_args, name: "test")).to be_nil
    end

    context "without any dependencies updated" do
      let(:result) { nil }

      it "returns nil" do
        expect(described_class.call(**args)).to be_nil
      end
    end
  end
end
