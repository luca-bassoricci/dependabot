# frozen_string_literal: true

# rubocop:disable Rails/HttpPositionalArguments
RSpec.shared_context("with api helper") do
  def post_json(uri, body, gitlab_token = nil)
    post(uri, json(body), headers(gitlab_token))
  end

  def put_json(uri, body, gitlab_token = nil)
    put(uri, json(body), headers(gitlab_token))
  end

  def json(body)
    body.is_a?(Hash) ? body.to_json : File.read(body)
  end

  def hash(body)
    JSON.parse(File.read(body), symbolize_names: true)
  end

  private

  def headers(token)
    { "content_type" => "application/json", "X-Gitlab-Token" => token }.compact_blank
  end
end
# rubocop:enable Rails/HttpPositionalArguments
