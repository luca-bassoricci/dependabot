# frozen_string_literal: true

describe "Update check" do
  include_context "webmock"

  context DependabotServices::UpdateChecker do
    before do
      stub_gitlab
    end

    let(:files) { DependabotServices::FileFetcher.call(source).files }
    let(:dep) do
      DependabotServices::FileParser.call(dependency_files: files, source: source).parse.select(&:top_level?).first
    end

    it "returns update checker" do
      expect(DependabotServices::UpdateChecker.call(dependency: dep, dependency_files: files)).to be_an_instance_of(
        Dependabot::Bundler::UpdateChecker
      )
    end
  end

  context DependabotServices::RequirementChecker do
    let(:checker) { double("checker") }
    let(:requirement_checker) { DependabotServices::RequirementChecker.call(checker) }

    it "returns update not possible when requirements can't be unlocked" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all).and_return(false)

      expect(requirement_checker).to eq(:update_not_possible)
    end

    it "returns update not possible when requirements can be unlocked" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none).and_return(false)

      expect(requirement_checker).to eq(:update_not_possible)
    end

    it "returns none requirements to unlock" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none).and_return(true)

      expect(requirement_checker).to eq(:none)
    end

    it "returns own requirements to unlock" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(true)

      expect(requirement_checker).to eq(:own)
    end

    it "returns all requirements to unlock" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all).and_return(true)

      expect(requirement_checker).to eq(:all)
    end
  end
end
