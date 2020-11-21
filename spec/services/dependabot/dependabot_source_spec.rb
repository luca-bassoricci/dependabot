# frozen_string_literal: true

describe Dependabot::DependabotSource do
  let(:uri) { URI(Settings.gitlab_url) }

  it "returns source" do
    src = described_class.call(repo: "test-repo", directory: "/", branch: "master")

    actual = [src.provider, src.hostname, src.api_endpoint, src.repo, src.directory, src.branch]
    expected = ["gitlab", uri.host, "#{uri}/api/v4", "test-repo", "/", "master"]
    expect(actual).to eq(expected)
  end
end
