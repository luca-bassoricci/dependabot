# frozen_string_literal: true

# Simple sinatra app to mock gitlab interactions for e2e test

require "sinatra"
require "sinatra/namespace"

repo_url = "/projects/test-repo"
ref = "88b0f12ab"

namespace "/api/v4" do
  # project
  get repo_url do
    [200, [File.read("responses/gitlab/project.json")]]
  end

  # repo tree
  get "#{repo_url}/repository/tree" do
    [200, [File.read("responses/gitlab/files.json")]]
  end

  # files
  get "#{repo_url}/repository/files/*/raw" do
    [200, [File.read("responses/gitlab/dependabot.yml")]]
  end

  get "#{repo_url}/repository/files/:file" do
    [200, [File.read("responses/gitlab/#{params['file']}.json")]]
  end

  # branches
  get "#{repo_url}/repository/branches/:name" do
    params["name"] == "master" ? [200, [{ commit: { id: ref } }.to_json]] : [404, [[].to_json]]
  end

  post "#{repo_url}/repository/branches" do
    [200, [[].to_json]]
  end

  # users
  get "/users" do
    [200, [File.read("responses/gitlab/users.json")]]
  end

  # merge requests
  get "#{repo_url}/merge_requests" do
    [200, [[].to_json]]
  end

  post "#{repo_url}/merge_requests" do
    [200, [File.read("responses/gitlab/merge_request.json")]]
  end

  put "#{repo_url}/merge_requests/:iid/approvers" do
    [200, [[].to_json]]
  end

  put "/projects/:id/merge_requests/:iid/merge" do
    [200, [[].to_json]]
  end

  # commits
  post "#{repo_url}/repository/commits" do
    [200, [[].to_json]]
  end

  # labels
  get "#{repo_url}/labels" do
    [200, [File.read("responses/gitlab/labels.json")]]
  end
end
