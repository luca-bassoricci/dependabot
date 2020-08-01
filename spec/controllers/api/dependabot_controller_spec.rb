# frozen_string_literal: true

describe Api::DependabotController do
  include_context "api"

  it "handles successfull run" do
    expect(Webhooks::PushEventHandler).to receive(:call).and_return(
      [
        OpenStruct.new(
          name: "dependabot:bundler",
          cron: "0 0 0 0 0",
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
    expect(Webhooks::PushEventHandler).to receive(:call).and_raise(StandardError.new("Unexpected"))

    post_json("/api/dependabot", "spec/fixture/api/webhooks/push.json")

    expect(last_response.status).to eq(500)
    expect(JSON.parse(last_response.body, symbolize_names: true)).to eq(message: "Unexpected")
  end
end
