# frozen_string_literal: true

describe Dependabot::DependencyFetcher do
  include_context "webmock"
  include_context "dependabot"

  before do
    stub_gitlab
  end

  it "returns top level dependencies" do
    dependencies = Dependabot::DependencyFetcher.call(
      source: source,
      dependency_files: fetcher.files,
      package_manager: package_manager
    )

    expect(dependencies).to eq([dependency])
  end
end
