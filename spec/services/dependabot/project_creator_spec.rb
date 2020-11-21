# frozen_string_literal: true

describe Dependabot::ProjectCreator do
  include_context "dependabot"

  let(:project) { Project.new(name: repo, config: []) }

  subject { described_class.call(repo) }

  before do
    allow(Gitlab::ConfigFetcher).to receive(:call).with(repo) { raw_config }
  end

  it "creates new project" do
    subject

    expect(Project.find_by(name: repo)).to_not be_nil
  end

  it "updates existing project" do
    project.save!

    subject

    expect(project.reload.symbolized_config).to eq(dependabot_config)
  end
end
