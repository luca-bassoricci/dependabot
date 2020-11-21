# frozen_string_literal: true

describe Dependabot::UpdateChecker do
  subject(:update_checker_return) do
    described_class.call(
      dependency: dependency,
      dependency_files: fetcher.files,
      allow: allow_conf,
      ignore: ignore_conf
    )
  end

  include_context "webmock"
  include_context "dependabot"

  let(:checker) { instance_double("Dependabot::Bundler::UpdateChecker") }
  let(:latest_version) { "2.2.1" }
  let(:vulnerable) { false }
  let(:up_to_date) { false }
  let(:unlocked_or_can_be) { true }
  let(:can_update_own_unlock) { true }
  let(:can_update_all_unlock) { true }
  let(:can_update_none_unlock) { true }

  before do
    stub_gitlab
    allow(Dependabot::Bundler::UpdateChecker).to receive(:new) { checker }
    allow(checker).to receive(:vulnerable?) { vulnerable }
    allow(checker).to receive(:up_to_date?) { up_to_date }
    allow(checker).to receive(:requirements_unlocked_or_can_be?) { unlocked_or_can_be }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own) { can_update_own_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all) { can_update_all_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none) { can_update_none_unlock }
    allow(checker).to receive(:latest_version) { Gem::Version.new(latest_version) }
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

    context "when only development dependencies are allowed" do
      let(:allow_conf) { [{ dependency_type: "development" }] }

      it { is_expected.to be_nil }
    end

    context "when only indirect dependencies are allowed" do
      let(:allow_conf) { [{ dependency_type: "indirect" }] }

      it { is_expected.to be_nil }
    end

    context "when only security updates are allowed" do
      let(:allow_conf) { [{ dependency_type: "security" }] }

      it { is_expected.to be_nil }
    end

    context "when only explicitly allowed dependencies don't match" do
      let(:allow_conf) { [{ dependency_name: "rspec" }] }

      it { is_expected.to be_nil }
    end

    context "when dependency is ignored" do
      let(:ignore_conf) { [{ dependency_name: "config", versions: ["~> 2"] }] }

      it { is_expected.to be_nil }
    end
  end

  context "when dependency can be updated" do
    let(:updated_deps) do
      {
        name: "#{dependency.name} #{dependency.version} => #{latest_version}",
        dependencies: updated_dependencies,
        vulnerable: checker.vulnerable?,
        security_advisories: checker.security_advisories
      }
    end

    before do
      allow(checker).to receive(:latest_version) { latest_version }
      allow(checker).to receive(:security_advisories).and_return([])
      allow(checker).to receive(:updated_dependencies) { updated_dependencies }
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

    context "when only production dependencies are allowed" do
      let(:allow_conf) { [{ dependency_type: "production" }] }

      it { is_expected.to eq(updated_deps) }
    end

    context "when only explicitly allowed dependencies match" do
      let(:allow_conf) { [{ dependency_name: "config" }] }

      it { is_expected.to eq(updated_deps) }
    end
  end
end
