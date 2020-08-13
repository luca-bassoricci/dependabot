# frozen_string_literal: true

require "rack/test"

RSpec.shared_context("rack_test") do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def post_json(uri, body, gitlab_token = "gitlab_auth_token")
    header("X-Gitlab-Token", gitlab_token)
    post(uri, body.is_a?(Hash) ? body.to_json : File.read(body), { "CONTENT_TYPE" => "application/json" })
  end
end
