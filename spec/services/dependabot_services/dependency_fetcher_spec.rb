# frozen_string_literal: true

describe DependabotServices::DependencyFetcher do
  include_context "webmock"

  let(:package_manager) { "bundler" }
  let(:fetcher) { DependabotServices::FileFetcher.call(source: source, package_manager: package_manager) }
  let(:dependency) do
    Dependabot::Dependency.new(
      name: "config",
      package_manager: package_manager,
      version: "2.1.0",
      requirements: [requirement: "~> 2.1.0", groups: [:default], source: nil, file: "Gemfile"]
    )
  end

  before do
    stub_gitlab
  end

  it "returns top level dependencies" do
    dependencies = DependabotServices::DependencyFetcher.call(
      source: source,
      dependency_files: fetcher.files,
      package_manager: package_manager
    )

    expect(dependencies).to eq([dependency])
  end
end
