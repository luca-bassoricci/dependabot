# frozen_string_literal: true

RSpec.shared_context("with api helper") do
  def post_json(uri, body, gitlab_token = nil)
    post(uri, params: json(body), headers: headers(gitlab_token))
  end

  def put_json(uri, body, gitlab_token = nil)
    put(uri, params: json(body), headers: headers(gitlab_token))
  end

  def json(body)
    body.is_a?(Hash) ? body : hash(body)
  end

  def hash(body)
    JSON.parse(File.read(body), symbolize_names: true)
  end

  private

  def headers(token)
    { "content_type" => "application/json", "X-Gitlab-Token" => token }.compact_blank
  end
end
