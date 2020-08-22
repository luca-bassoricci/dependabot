# frozen_string_literal: true

describe Credentials do
  it "returns credentials" do
    expect(Credentials.fetch).to eq(
      [
        {
          "type" => "git_source",
          "host" => "github.com",
          "username" => "x-access-token",
          "password" => Settings.github_access_token
        },
        {
          "type" => "git_source",
          "host" => URI(Settings.gitlab_url).host,
          "username" => "x-access-token",
          "password" => Settings.gitlab_access_token
        }
      ]
    )
  end
end
