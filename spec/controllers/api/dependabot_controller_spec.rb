# frozen_string_literal: true

describe Api::DependabotController do
  include_context "api"

  it "calls push event handler" do
    expect(Webhooks::PushEventHandler).to receive(:call)

    post_json("/api/dependabot", "spec/fixture/api/webhooks/push.json")
  end
end
