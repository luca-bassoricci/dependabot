# frozen_string_literal: true

require "webmock/rspec"

RSpec.shared_context("webmock") do
  let(:repo_url) { "https://#{Settings.gitlab_hostname}/api/v4/projects/test-repo/repository" }

  def stub_gitlab
    stub_request(:get, "#{repo_url}/branches/master")
      .to_return(status: 200, body: body("gitlab", "project.json"))
    stub_request(:get, %r{#{repo_url}/tree})
      .to_return(status: 200, body: body("gitlab", "files.json"))
    stub_request(:get, %r{#{repo_url}/files/Gemfile\?})
      .to_return(status: 200, body: body("gitlab", "gemfile.json"))
    stub_request(:get, %r{#{repo_url}/files/Gemfile.lock})
      .to_return(status: 200, body: body("gitlab", "gemfile.lock.json"))
    stub_request(:get, "#{source.api_endpoint}/users?search=andrcuns")
      .to_return(status: 200, body: body("gitlab", "user.json"))
  end

  def body(type, file)
    File.read("spec/fixture/webmock/responses/#{type}/#{file}")
  end
end
