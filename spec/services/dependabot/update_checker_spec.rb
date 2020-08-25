# frozen_string_literal: true

describe Dependabot::UpdateChecker do
  include_context "webmock"
  include_context "dependabot"

  let(:checker) { double("checker") }
  let(:vulnerable) { false }
  let(:up_to_date) { false }
  let(:unlocked_or_can_be) { true }
  let(:can_update_own_unlock) { true }
  let(:can_update_all_unlock) { true }
  let(:can_update_none_unlock) { true }

  subject do
    described_class.call(
      dependency: dependency,
      dependency_files: fetcher.files,
      allow: allow_conf,
      ignore: ignore_conf
    )
  end

  before do
    stub_gitlab
    allow(Dependabot::Bundler::UpdateChecker).to receive(:new) { checker }
    allow(checker).to receive(:vulnerable?) { vulnerable }
    allow(checker).to receive(:up_to_date?) { up_to_date }
    allow(checker).to receive(:requirements_unlocked_or_can_be?) { unlocked_or_can_be }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own) { can_update_own_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all) { can_update_all_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none) { can_update_none_unlock }
    allow(checker).to receive(:updated_dependencies) { updated_dependencies }
  end

  context "returns empty array" do
    context do
      let(:up_to_date) { true }

      it "when dependency up to date" do
        expect(subject).to eq([])
      end
    end

    context do
      let(:can_update_own_unlock) { false }
      let(:can_update_all_unlock) { false }

      it "when update not possible with requirements unlocked" do
        expect(subject).to eq([])
      end
    end

    context do
      let(:unlocked_or_can_be) { false }
      let(:can_update_none_unlock) { false }

      it "when update not possible with requirements locked" do
        expect(subject).to eq([])
      end
    end

    context do
      let(:allow_conf) { [{ dependency_type: "development" }] }

      it "when only development dependencies are allowed" do
        expect(subject).to eq([])
      end
    end

    context do
      let(:allow_conf) { [{ dependency_type: "indirect" }] }

      it "when only indirect dependencies are allowed" do
        expect(subject).to eq([])
      end
    end

    context do
      let(:allow_conf) { [{ dependency_type: "security" }] }

      it "when only security updates are allowed" do
        expect(subject).to eq([])
      end
    end

    context do
      let(:allow_conf) { [{ dependency_name: "rspec" }] }

      it "when only explicitly allowed dependencies don't match" do
        expect(subject).to eq([])
      end
    end

    context do
      let(:ignore_conf) { [{ dependency_name: "config", versions: ["~> 2"] }] }

      before do
        allow(checker).to receive(:latest_version) { Gem::Version.new("2.2.0") }
      end

      it "when dependency is ignored" do
        expect(subject).to eq([])
      end
    end
  end

  context "returns updated dependencies" do
    context do
      let(:unlocked_or_can_be) { false }

      it "when no requirements to unlock" do
        expect(subject).to eq(updated_dependencies)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :none)
      end
    end

    context do
      it "when own requirements to unlock" do
        expect(subject).to eq(updated_dependencies)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :own)
      end
    end

    context do
      let(:can_update_own_unlock) { false }

      it "when all requirements to unlock" do
        expect(subject).to eq(updated_dependencies)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :all)
      end
    end

    context do
      let(:allow_conf) { [{ dependency_type: "production" }] }

      it "when only production dependencies are allowed" do
        expect(subject).to eq(updated_dependencies)
      end
    end

    context do
      let(:allow_conf) { [{ dependency_name: "config" }] }

      it "when only explicitly allowed dependencies match" do
        expect(subject).to eq(updated_dependencies)
      end
    end
  end
end
