# frozen_string_literal: true

describe Dependabot::UpdateChecker do
  include_context "webmock"
  include_context "dependabot"

  let(:checker) { double("checker") }

  subject { described_class.call(dependency: dependency, dependency_files: fetcher.files, ignore: ignore_conf) }

  before do
    stub_gitlab
    allow(Dependabot::Bundler::UpdateChecker).to receive(:new) { checker }
    allow(checker).to receive(:up_to_date?) { up_to_date }
    allow(checker).to receive(:requirements_unlocked_or_can_be?) { unlocked_or_can_be }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own) { can_update_own_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all) { can_update_all_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none) { can_update_none_unlock }
    allow(checker).to receive(:updated_dependencies) { updated_dependencies }
  end

  context "updated dependencies" do
    let(:up_to_date) { true }
    let(:unlocked_or_can_be) { true }
    let(:can_update_own_unlock) { true }
    let(:can_update_all_unlock) { true }
    let(:can_update_none_unlock) { true }

    context "array" do
      let(:up_to_date) { true }

      it "is empty when dependency up to date" do
        expect(subject).to eq([])
      end
    end

    context "array" do
      let(:up_to_date) { false }
      let(:unlocked_or_can_be) { true }
      let(:can_update_own_unlock) { false }
      let(:can_update_all_unlock) { false }

      it "is empty when update not possible with requirements unlocked" do
        expect(subject).to eq([])
      end
    end

    context "array" do
      let(:up_to_date) { false }
      let(:unlocked_or_can_be) { false }
      let(:can_update_none_unlock) { false }

      it "is empty when update not possible with requirements locked" do
        expect(subject).to eq([])
      end
    end

    context "array" do
      let(:up_to_date) { false }
      let(:unlocked_or_can_be) { false }
      let(:can_update_none_unlock) { true }
      let(:ignore_conf) { [{ dependency_name: "config", versions: ["~> 2"] }] }

      before do
        allow(checker).to receive(:latest_version) { Gem::Version.new("2.2.0") }
      end

      it "is empty when dependency is ignored" do
        expect(subject).to eq([])
      end
    end

    context "array" do
      let(:up_to_date) { false }
      let(:unlocked_or_can_be) { false }
      let(:can_update_none_unlock) { true }

      it "contains updated dependencies when no requirements to unlock" do
        expect(subject).to eq(updated_dependencies)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :none)
      end
    end

    context "array" do
      let(:up_to_date) { false }
      let(:unlocked_or_can_be) { true }
      let(:can_update_own_unlock) { true }

      it "contains updated dependencies when own requirements to unlock" do
        expect(subject).to eq(updated_dependencies)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :own)
      end
    end

    context "array" do
      let(:up_to_date) { false }
      let(:unlocked_or_can_be) { true }
      let(:can_update_own_unlock) { false }
      let(:can_update_all_unlock) { true }

      it "contains updated dependencies when all requirements to unlock" do
        expect(subject).to eq(updated_dependencies)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :all)
      end
    end
  end
end
