# frozen_string_literal: true

describe Dependabot::UpdateChecker, epic: :services, feature: :dependabot do
  subject(:update_checker_return) do
    described_class.call(
      dependency: dependency,
      dependency_files: fetcher.files,
      config: config,
      repo_contents_path: nil
    )
  end

  include_context "with webmock"
  include_context "with dependabot helper"

  let(:checker) { instance_double("Dependabot::Bundler::UpdateChecker") }
  let(:rule_handler) { instance_double("Dependabot::RuleHandler") }
  let(:latest_version) { "2.2.1" }
  let(:vulnerable) { false }
  let(:up_to_date) { false }
  let(:unlocked_or_can_be) { true }
  let(:can_update_own_unlock) { true }
  let(:can_update_all_unlock) { true }
  let(:can_update_none_unlock) { true }
  let(:versioning_strategy) { :bump_versions }
  let(:can_update) { true }
  let(:credentials) { [*Dependabot::Credentials.call, *dependabot_config.first[:registries]] }
  let(:config) do
    {
      **dependabot_config.first,
      allow: allow_conf,
      ignore: ignore_conf,
      versioning_strategy: versioning_strategy
    }
  end
  let(:checker_args) do
    args = {
      dependency: dependency,
      dependency_files: fetcher.files,
      credentials: credentials,
      ignored_versions: [],
      raise_on_ignored: true
    }
    args[:requirements_update_strategy] = versioning_strategy if versioning_strategy != :lockfile_only
    args
  end

  before do
    stub_gitlab

    allow(Dependabot::FileUpdater).to receive(:call).with(
      dependencies: updated_dependencies,
      dependency_files: fetcher.files,
      package_manager: package_manager,
      repo_contents_path: nil,
      credentials: credentials
    ).and_return(updated_files)

    allow(Dependabot::RuleHandler).to receive(:new).with(
      dependency: dependency,
      checker: checker,
      config: config
    ).and_return(rule_handler)
    allow(rule_handler).to receive(:allowed?) { can_update }

    allow(Dependabot::Bundler::UpdateChecker).to receive(:new).with(checker_args) { checker }
    allow(checker).to receive(:vulnerable?) { vulnerable }
    allow(checker).to receive(:up_to_date?) { up_to_date }
    allow(checker).to receive(:requirements_unlocked_or_can_be?) { unlocked_or_can_be }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own) { can_update_own_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all) { can_update_all_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none) { can_update_none_unlock }
    allow(checker).to receive(:latest_version) { Gem::Version.new(latest_version) }
    allow(checker).to receive(:conflicting_dependencies).and_return([])
  end

  context "when update version is ignored" do
    before do
      allow(checker).to receive(:ignored_versions).and_return([">= 2.0"])
      allow(checker).to receive(:up_to_date?).and_raise(Dependabot::AllVersionsIgnored)
    end

    it { is_expected.to be_nil }
  end

  context "when nothing to update" do
    context "when dependency up to date" do
      let(:up_to_date) { true }

      it { is_expected.to be_nil }
    end

    context "when update not possible with requirements unlocked" do
      let(:can_update_own_unlock) { false }
      let(:can_update_all_unlock) { false }

      it { is_expected.to be_nil }
    end

    context "when update not possible with requirements locked" do
      let(:unlocked_or_can_be) { false }
      let(:can_update_none_unlock) { false }

      it { is_expected.to be_nil }
    end

    context "when update not allowed by rules" do
      let(:can_update) { false }

      it { is_expected.to be_falsey }
    end
  end

  context "when dependency can be updated" do
    let(:updated_deps) do
      Dependabot::UpdatedDependency.new(
        name: dependency.name,
        updated_files: updated_files,
        updated_dependencies: updated_dependencies,
        vulnerable: checker.vulnerable?,
        security_advisories: checker.security_advisories
      )
    end

    before do
      allow(checker).to receive(:latest_version) { latest_version }
      allow(checker).to receive(:security_advisories).and_return([])
      allow(checker).to receive(:updated_dependencies) { updated_dependencies }
    end

    context "when only lockfile updates are allowed" do
      let(:versioning_strategy) { :lockfile_only }

      it do
        expect(update_checker_return).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :none)
      end
    end

    context "when no requirements to unlock" do
      let(:unlocked_or_can_be) { false }

      it do
        expect(update_checker_return).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :none)
      end
    end

    context "when own requirements to unlock" do
      it do
        expect(update_checker_return).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :own)
      end
    end

    context "when all requirements to unlock" do
      let(:can_update_own_unlock) { false }

      it do
        expect(update_checker_return).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :all)
      end
    end
  end
end
