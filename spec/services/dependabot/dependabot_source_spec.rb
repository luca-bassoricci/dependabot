# frozen_string_literal: true

describe Dependabot::DependabotSource do
  it "returns source" do
    src = Dependabot::DependabotSource.call(repo: "test-repo")

    actual = [src.provider, src.hostname, src.api_endpoint, src.repo, src.directory, src.branch]
    expected = %w[gitlab gitlab.com https://gitlab.com/api/v4 test-repo / master]
    expect(actual).to eq(expected)
  end
end
