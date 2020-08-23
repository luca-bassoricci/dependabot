# frozen_string_literal: true

require "webmock/rspec"

# Stub responses from gitlab which is called by internal dependabot-core classes which
# are hard to track for purely functional mocking
RSpec.shared_context("webmock") do
  let(:repo_url) { "#{Settings.gitlab_url}/api/v4/projects/test-repo" }

  def stub_gitlab
    stub_request(:get, %r{#{repo_url}/repository/tree})
      .to_return(status: 200, body: body("files.json"))
    # Testing Gemfile with config and rspec as dependencies
    stub_request(:get, %r{#{repo_url}/repository/files/Gemfile\?})
      .to_return(status: 200, body: body("Gemfile.json"))
    # Testing Gemfile.lock with config and rspec as dependencies and it's sub dependencies
    stub_request(:get, %r{#{repo_url}/repository/files/Gemfile.lock})
      .to_return(status: 200, body: body("Gemfile.lock.json"))

    stub_request(:get, "#{repo_url}/repository/branches/master")
      .to_return(status: 200, body: { commit: { id: "88b0f12ab" } }.to_json)
    stub_request(:get, "#{source.api_endpoint}/users?search=andrcuns")
      .to_return(status: 200, body: [{ id: 10 }].to_json)
  end

  def body(file)
    File.read("spec/gitlab_mock/responses/gitlab/#{file}")
  end
end
