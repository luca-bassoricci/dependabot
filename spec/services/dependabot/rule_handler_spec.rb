# frozen_string_literal: true

describe Dependabot::RuleHandler, epic: :services, feature: :dependabot do
  subject(:rule_handler_return) do
    described_class.new(
      dependency: dependency,
      checker: checker,
      config: config
    ).update?
  end

  include_context "with webmock"
  include_context "with dependabot helper"

  let(:checker) { instance_double("Dependabot::Bundler::UpdateChecker") }
  let(:latest_version) { "2.2.1" }
  let(:versioning_strategy) { :bump_versions }
  let(:config) do
    {
      **dependabot_config.first,
      allow: allow_conf,
      ignore: ignore_conf,
      versioning_strategy: versioning_strategy
    }
  end

  before do
    allow(checker).to receive(:vulnerable?).and_return(false)
    allow(checker).to receive(:latest_version) { Gem::Version.new(latest_version) }
  end

  context "when only direct dependencies are allowed" do
    let(:allow_conf) { [{ dependency_type: "direct" }] }

    it { is_expected.to be_truthy }
  end

  context "when only development dependencies are allowed" do
    let(:allow_conf) { [{ dependency_type: "development" }] }

    it { is_expected.to be_falsey }
  end

  context "when only indirect dependencies are allowed" do
    let(:allow_conf) { [{ dependency_type: "indirect" }] }

    it { is_expected.to be_falsey }
  end

  context "when only security updates are allowed" do
    let(:allow_conf) { [{ dependency_type: "security" }] }

    it { is_expected.to be_falsey }
  end

  context "when only explicitly allowed dependencies don't match" do
    let(:allow_conf) { [{ dependency_name: "rspec" }] }

    it { is_expected.to be_falsey }
  end

  context "when dependency is ignored with versions" do
    let(:ignore_conf) { [{ dependency_name: "config", versions: ["~> 2"] }] }

    it { is_expected.to be_falsey }
  end

  context "when dependency minor version is ignored with update-types" do
    let(:ignore_conf) { [{ dependency_name: "config", update_types: ["version-update:semver-minor"] }] }

    it { is_expected.to be_falsey }
  end

  context "when dependency patch version is ignored with update-types" do
    let(:ignore_conf) { [{ dependency_name: "config", update_types: ["version-update:semver-patch"] }] }

    it { is_expected.to be_truthy }
  end

  context "when dependency major version is ignored with update-types" do
    let(:ignore_conf) { [{ dependency_name: "config", update_types: ["version-update:semver-major"] }] }

    it { is_expected.to be_truthy }
  end

  context "when only production dependencies are allowed" do
    let(:allow_conf) { [{ dependency_type: "production" }] }

    it { is_expected.to be_truthy }
  end

  context "when only explicitly allowed dependencies match" do
    let(:allow_conf) { [{ dependency_name: "config" }] }

    it { is_expected.to be_truthy }
  end
end
