# frozen_string_literal: true

describe DependabotServices::UpdateChecker do
  include_context "webmock"
  include_context "dependabot"

  let(:checker) { double("checker") }

  before do
    stub_gitlab
    allow(Dependabot::UpdateCheckers).to receive_message_chain("for_package_manager.new").and_return(checker)
  end

  it "returns if dependency up to date" do
    allow(checker).to receive(:up_to_date?).and_return(true)

    expect(checker).not_to receive(:updated_dependencies)

    expect(DependabotServices::UpdateChecker.call(dependency: dependency, dependency_files: fetcher.files)).to be_nil
  end

  it "returns if update not possible with requirements unlocked" do
    allow(checker).to receive(:up_to_date?).and_return(false)
    allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(false)
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all).and_return(false)

    expect(checker).not_to receive(:updated_dependencies)

    expect(DependabotServices::UpdateChecker.call(dependency: dependency, dependency_files: fetcher.files)).to be_nil
  end

  it "returns if update not possible with requirements locked" do
    allow(checker).to receive(:up_to_date?).and_return(false)
    allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(false)
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none).and_return(false)

    expect(checker).not_to receive(:updated_dependencies)

    expect(DependabotServices::UpdateChecker.call(dependency: dependency, dependency_files: fetcher.files)).to be_nil
  end

  it "calls with requirements to unlock :none" do
    allow(checker).to receive(:up_to_date?).and_return(false)
    allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(false)
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none).and_return(true)

    expect(checker).to receive(:updated_dependencies)
      .with(requirements_to_unlock: :none)
      .and_return(updated_dependencies)

    expect(DependabotServices::UpdateChecker.call(dependency: dependency, dependency_files: fetcher.files)).to eq(
      updated_dependencies
    )
  end

  it "calls with requirements to unlock :own" do
    allow(checker).to receive(:up_to_date?).and_return(false)
    allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(true)

    expect(checker).to receive(:updated_dependencies)
      .with(requirements_to_unlock: :own)
      .and_return(updated_dependencies)

    expect(DependabotServices::UpdateChecker.call(dependency: dependency, dependency_files: fetcher.files)).to eq(
      updated_dependencies
    )
  end

  it "calls with requirements to unlock :all" do
    allow(checker).to receive(:up_to_date?).and_return(false)
    allow(checker).to receive(:requirements_unlocked_or_can_be?).and_return(true)
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own).and_return(false)
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all).and_return(true)

    expect(checker).to receive(:updated_dependencies)
      .with(requirements_to_unlock: :all)
      .and_return(updated_dependencies)

    expect(DependabotServices::UpdateChecker.call(dependency: dependency, dependency_files: fetcher.files)).to eq(
      updated_dependencies
    )
  end
end
