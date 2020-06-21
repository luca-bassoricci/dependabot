# frozen_string_literal: true

require "webmock/rspec"

RSpec.shared_context("webmock") do
  let(:source) { DependabotSource.call("1") }
  let(:repo) { "#{source.api_endpoint}/projects/#{source.repo}/repository" }
  let(:rubygems) { "https://rubygems.org/api/v1" }

  def stub_gitlab # rubocop:disable Metrics/AbcSize
    stub_request(:get, "#{repo}/branches/#{source.branch}")
      .to_return(status: 200, body: body("gitlab", "project.json"))
    stub_request(:get, %r{#{repo}/tree})
      .to_return(status: 200, body: body("gitlab", "files.json"))
    stub_request(:get, %r{#{repo}/files/Gemfile\?})
      .to_return(status: 200, body: body("gitlab", "gemfile.json"))
    stub_request(:get, %r{#{repo}/files/Gemfile.lock})
      .to_return(status: 200, body: body("gitlab", "gemfile.lock.json"))
  end

  def stub_rubygems
    stub_request(:get, "#{rubygems}/versions/config.json")
      .to_return(status: 200, body: body("rubygems", "config.json"))
    stub_request(:get, "https://index.rubygems.org/versions")
      .to_return(status: 200, body: body("rubygems", "versions"))
    stub_request(:get, "https://index.rubygems.org/api/v1/dependencies")
      .to_return(status: 200, body: "")
    stub_request(:get, %r{https://index.rubygems.org/api/v1/dependencies\?gems})
      .to_return(status: 200, body: body("rubygems", "dependencies"))
  end

  def body(type, file)
    File.read("spec/webmock/responses/#{type}/#{file}")
  end
end
