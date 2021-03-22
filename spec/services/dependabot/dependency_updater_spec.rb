# frozen_string_literal: true

describe Dependabot::DependencyUpdater, epic: :services, feature: :dependabot do
  include_context "with webmock"
  include_context "with dependabot helper"

  let(:config) { dependabot_config.first }
  let(:updater_args) do
    {
      project_name: repo,
      config: config,
      fetcher: fetcher
    }
  end

  let(:result) do
    Dependabot::UpdatedDependency.new(
      name: dependency.name,
      updated_files: updated_files,
      updated_dependencies: updated_dependencies,
      vulnerable: false,
      security_advisories: []
    )
  end

  before do
    stub_gitlab

    allow(Dependabot::FileParser).to receive(:call)
      .with(
        source: fetcher.source,
        dependency_files: fetcher.files,
        package_manager: package_manager
      )
      .and_return([dependency])
    allow(Dependabot::UpdateChecker).to receive(:call)
      .with(
        dependency: dependency,
        dependency_files: fetcher.files,
        config: config
      )
      .and_return(result)
  end

  it "returns updated dependencies" do
    expect(described_class.call(updater_args)).to eq([result])
  end

  it "returns single updated dependency" do
    expect(described_class.call(**updater_args, name: dependency.name)).to eq(result)
  end

  it "raises error if dependency not found" do
    expect { described_class.call(**updater_args, name: "test") }.to raise_error(
      "test not found in project dependencies"
    )
  end
end
