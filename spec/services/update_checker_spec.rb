# frozen_string_literal: true

describe UpdateChecker do
  include_context "webmock"

  before do
    stub_gitlab
  end

  let(:files) { FileFetcher.call(source).files }
  let(:dep) { FileParser.call(dependency_files: files, source: source).parse.select(&:top_level?).first }
  let(:update_checker) { UpdateChecker.call(dependency: dep, dependency_files: files) }

  context UpdateChecker do
    it "return update checker" do
      expect(update_checker).to be_an_instance_of(UpdateChecker)
    end
  end

  context "requirements to unlock" do
    let(:checker) { double("checker") }

    before do
      allow(Dependabot::UpdateCheckers).to receive_message_chain("for_package_manager.new").and_return(checker)
    end

    it "returns update not possible when requirements can't be unlocked" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all).and_return(false)

      expect(update_checker.requirements_to_unlock).to eq(:update_not_possible)
    end

    it "returns update not possible when requirements can be unlocked" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none).and_return(false)

      expect(update_checker.requirements_to_unlock).to eq(:update_not_possible)
    end

    it "returns none requirements to unlock" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none).and_return(true)

      expect(update_checker.requirements_to_unlock).to eq(:none)
    end

    it "returns own requirements to unlock" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(true)

      expect(update_checker.requirements_to_unlock).to eq(:own)
    end

    it "returns all requirements to unlock" do
      allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(false)
      allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all).and_return(true)

      expect(update_checker.requirements_to_unlock).to eq(:all)
    end
  end
end
