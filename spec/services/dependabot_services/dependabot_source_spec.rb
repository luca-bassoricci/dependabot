# frozen_string_literal: true

describe DependabotServices::DependabotSource do
  it "returns source" do
    src = DependabotServices::DependabotSource.call(repo: "1")

    actual = [src.provider, src.hostname, src.api_endpoint, src.repo, src.directory, src.branch]
    expected = %w[gitlab gitlab.com https://gitlab.com/api/v4 1 / master]
    expect(actual).to eq(expected)
  end
end
