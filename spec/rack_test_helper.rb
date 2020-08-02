# frozen_string_literal: true

require "rack/test"

RSpec.shared_context("rack_test") do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def post_json(uri, json_path, gitlab_token = "gitlab_auth_token")
    header("X-Gitlab-Token", gitlab_token)
    post(uri, File.read(json_path), { "CONTENT_TYPE" => "application/json" })
  end
end
