# frozen_string_literal: true

describe Dependabot::DependencyFetcher do
  include_context "webmock"
  include_context "dependabot"

  subject do
    described_class.call(
      source: source,
      dependency_files: fetcher.files,
      package_manager: package_manager
    )
  end

  before do
    stub_gitlab
  end

  it "fetches defined dependencies" do
    expect(subject.size).to eq(19)
    expect(subject).to include(dependency)
  end
end
