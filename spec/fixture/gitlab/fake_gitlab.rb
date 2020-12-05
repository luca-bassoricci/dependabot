# frozen_string_literal: true

# Simple sinatra app to mock gitlab interactions for e2e test

require "sinatra/base"
require "sinatra/namespace"
require "json"

class FakeGitlab < Sinatra::Base
  REPO_URL = "/projects/test-repo"
  REF = "88b0f12ab"

  register Sinatra::Namespace

  namespace "/api/v4" do
    # project
    get REPO_URL do
      [200, [file("responses/project.json")]]
    end

    # repo tree
    get "#{REPO_URL}/repository/tree" do
      [200, [file("responses/files.json")]]
    end

    # files
    get "#{REPO_URL}/repository/files/*/raw" do
      [200, [file("responses/dependabot.yml")]]
    end

    get "#{REPO_URL}/repository/files/:file" do
      [200, [file("responses/#{params['file']}.json")]]
    end

    # branches
    get "#{REPO_URL}/repository/branches/:name" do
      params["name"] == "master" ? [200, [{ commit: { id: REF } }.to_json]] : [404, [[].to_json]]
    end

    post "#{REPO_URL}/repository/branches" do
      [200, [[].to_json]]
    end

    # users
    get "/users" do
      [200, [file("responses/users.json")]]
    end

    # merge requests
    get "#{REPO_URL}/merge_requests" do
      body = if params["source_branch"].match?("dependabot-bundler-sinatra")
               [JSON.parse(file("responses/merge_request_sinatra.json"))]
             else
               []
             end

      [200, [body.to_json]]
    end

    post "#{REPO_URL}/merge_requests" do
      body = if params["source_branch"].match?("dependabot-bundler-sinatra")
               file("responses/merge_request_sinatra.json")
             else
               file("responses/merge_request_config.json")
             end
      [200, [body]]
    end

    put "#{REPO_URL}/merge_requests/:iid/approvers" do
      [200, [[].to_json]]
    end

    put "/projects/:id/merge_requests/:iid/merge" do
      [200, [[].to_json]]
    end

    # commits
    post "#{REPO_URL}/repository/commits" do
      [200, [[].to_json]]
    end

    # labels
    get "#{REPO_URL}/labels" do
      [200, [file("responses/labels.json")]]
    end
  end

  private

  # Read file relative to this path
  #
  # @param [String] path
  # @return [String]
  def file(path)
    File.read(File.join(File.dirname(__FILE__), path))
  end
end

FakeGitlab.start!
