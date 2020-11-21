# frozen_string_literal: true

describe Dependabot::ProjectCreator do
  include_context "dependabot"

  let(:project) { Project.new(name: repo, config: []) }

  before do
    allow(Gitlab::ConfigFetcher).to receive(:call).with(repo) { raw_config }
  end

  it "creates new project" do
    described_class.call(repo)
    expect(Project.find_by(name: repo)).not_to be_nil
  end

  it "updates existing project" do
    project.save!

    described_class.call(repo)
    expect(project.reload.symbolized_config).to eq(dependabot_config)
  end
end
