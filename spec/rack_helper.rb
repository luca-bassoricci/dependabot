# frozen_string_literal: true

require "rack/test"

# rubocop:disable Rails/HttpPositionalArguments
RSpec.shared_context("with rack_test") do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def post_json(uri, body, gitlab_token = nil)
    header("X-Gitlab-Token", gitlab_token) if gitlab_token
    post(uri, body.is_a?(Hash) ? body.to_json : File.read(body), { "CONTENT_TYPE" => "application/json" })
  end

  def put_json(uri, body, gitlab_token = nil)
    header("X-Gitlab-Token", gitlab_token) if gitlab_token
    put(uri, body.is_a?(Hash) ? body.to_json : File.read(body), { "CONTENT_TYPE" => "application/json" })
  end
end
# rubocop:enable Rails/HttpPositionalArguments
