# frozen_string_literal: true

describe Api::HooksController do
  include_context "rack_test"

  context "handles valid" do
    let(:jobs) do
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
    end
    let(:merge_request) do
      MergeRequest.new(iid: 1, package_manager: "bundler", state: "closed", auto_merge: false, dependencies: "test")
    end

    before do
      allow(Webhooks::PushEventHandler).to receive(:call) { jobs }
      allow(Webhooks::MergeRequestEventHandler).to receive(:call) { merge_request }
    end

    it "push event" do
      post_json("/api/hooks", "spec/fixture/api/webhooks/push.json")

      expect(last_response.status).to eq(200)
    end

    it "merge request close event" do
      post_json("/api/hooks", "spec/fixture/api/webhooks/mr_close.json")

      expect(last_response.status).to eq(200)
      expect(Webhooks::MergeRequestEventHandler).to have_received(:call).with("dependabot-gitlab/test", 69)
    end
  end

  context "handles" do
    let(:error) { StandardError.new("Unexpected") }

    before do
      allow(Webhooks::PushEventHandler).to receive(:call).and_raise(error)
      allow(Raven).to receive(:capture_exception)
    end

    it "system error" do
      post_json("/api/hooks", "spec/fixture/api/webhooks/push.json")

      expect(Raven).to have_received(:capture_exception).with(error)
      expect(last_response.status).to eq(500)
      expect(JSON.parse(last_response.body, symbolize_names: true)).to eq(
        status: 500,
        error: "Unexpected"
      )
    end

    it "invalid request" do
      post_json("/api/hooks", { "funky" => "object" })

      expect(last_response.status).to eq(400)
      expect(JSON.parse(last_response.body, symbolize_names: true)).to eq(
        status: 400,
        error: "Unsupported or missing parameter 'object_kind'"
      )
    end

    it "unauthorized request" do
      post_json("/api/hooks", "spec/fixture/api/webhooks/push.json", "invalid_token")

      expect(last_response.status).to eq(401)
      expect(JSON.parse(last_response.body, symbolize_names: true)).to eq(
        status: 401,
        error: "Invalid gitlab authentication token"
      )
    end
  end
end
