# frozen_string_literal: true

describe Dependabot::DependencyUpdater, epic: :services, feature: :dependabot do
  include_context "with webmock"
  include_context "with dependabot helper"

  let(:config) { dependabot_config.first }
  let(:updated_dependency) do
    {
      updated_dependencies: updated_dependencies,
      vulnerable: false,
      security_advisories: []
    }
  end

  let(:result) do
    [
      Dependabot::UpdatedDependency.new(
        name: dependency.name,
        updated_files: updated_files,
        **updated_dependency
      )
    ]
  end

  before do
    stub_gitlab

    allow(Dependabot::FileParser).to receive(:call) { [dependency] }
    allow(Dependabot::UpdateChecker).to receive(:call) { updated_dependency }
    allow(Dependabot::FileUpdater).to receive(:call) { updated_files }
  end

  it "returns updated dependencies" do
    expect(described_class.call(repo, config, fetcher)).to eq(result)
  end

  it "returns single updated dependency" do
    expect(described_class.new(repo, config, fetcher).updated_depedency(dependency.name)).to eq(result.first)
  end

  it "raises error if dependency not found" do
    expect { described_class.new(repo, config, fetcher).updated_depedency("test") }.to raise_error(
      "test not found in project dependencies"
    )
  end
end
