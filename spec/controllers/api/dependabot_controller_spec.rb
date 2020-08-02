# frozen_string_literal: true

describe Api::DependabotController do
  include_context "rack_test"

  it "handles successfull run" do
    expect(Webhooks::PushEventHandler).to receive(:call).and_return(
      [
        OpenStruct.new(
          name: "dependabot:bundler",
          cron: "5 4 * * *",
          class: "DependencyUpdateJob",
          args: { repo: "dependabot", package_manager: "bundler" },
          active_job: true,
          description: "test"
        )
      ]
    )

    post_json("/api/dependabot", "spec/fixture/api/webhooks/push.json")

    expect(last_response.status).to eq(200)
  end

  it "handles error" do
    error = StandardError.new("Unexpected")
    expect(Webhooks::PushEventHandler).to receive(:call).and_raise(error)
    expect(Raven).to receive(:capture_exception).with(error)

    post_json("/api/dependabot", "spec/fixture/api/webhooks/push.json")

    expect(last_response.status).to eq(500)
    expect(JSON.parse(last_response.body, symbolize_names: true)).to eq(
      status: 500,
      error: "Unexpected"
    )
  end

  it "handles unsupported hook type" do
    post_json("/api/dependabot", "spec/fixture/api/webhooks/tag_push.json")

    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body, symbolize_names: true)).to eq(
      status: 400,
      error: "Unsupported or missing parameter 'object_kind'"
    )
  end

  it "returns unauthorized error" do
    post_json("/api/dependabot", "spec/fixture/api/webhooks/push.json", "invalid_token")

    expect(last_response.status).to eq(401)
    expect(JSON.parse(last_response.body, symbolize_names: true)).to eq(
      status: 401,
      error: "Invalid gitlab authentication token"
    )
  end
end
