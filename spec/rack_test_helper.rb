# frozen_string_literal: true

require "rack/test"

RSpec.shared_context("rack_test") do # rubocop:disable RSpec/ContextWording
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def post_json(uri, body, gitlab_token = "gitlab_auth_token")
    header("X-Gitlab-Token", gitlab_token)
    # rubocop:disable Rails/HttpPositionalArguments
    post(uri, body.is_a?(Hash) ? body.to_json : File.read(body), { "CONTENT_TYPE" => "application/json" })
    # rubocop:enable Rails/HttpPositionalArguments
  end
end
