# frozen_string_literal: true

describe Api::HooksController, type: :config, epic: :controllers do
  include_context "with rack_test"
  include_context "with config helper"

  context "with successful response" do
    let(:project) { Project.new(name: "project") }
    let(:merge_request) do
      MergeRequest.new(
        iid: 1,
        package_ecosystem: "bundler",
        state: "closed",
        auto_merge: false,
        dependencies: "test",
        project: project
      )
    end

    before do
      allow(Webhooks::PushEventHandler).to receive(:call) { project }
      allow(Webhooks::MergeRequestEventHandler).to receive(:call) { merge_request }
      allow(Webhooks::CommentEventHandler).to receive(:call).and_return(nil)
      allow(Webhooks::PipelineEventHandler).to receive(:call).and_return(nil)
    end

    it "push event" do
      post_json("/api/hooks", "spec/fixture/gitlab/webhooks/push.json")

      aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq(project.to_json)
      end
    end

    it "merge request close event" do
      post_json("/api/hooks", "spec/fixture/gitlab/webhooks/mr_close.json")

      aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq(merge_request.to_json)
        expect(Webhooks::MergeRequestEventHandler).to have_received(:call).with(
          project_name: "dependabot-gitlab/test",
          mr_iid: 69,
          action: "close"
        )
      end
    end

    it "comment event" do
      post_json("/api/hooks", "spec/fixture/gitlab/webhooks/comment.json")

      aggregate_failures do
        expect(last_response.status).to eq(202)
        expect(last_response.body).to eq({}.to_json)
        expect(Webhooks::CommentEventHandler).to have_received(:call).with(
          "3343534",
          "test comment",
          "dependabot-gitlab/test",
          69
        )
      end
    end

    it "pipeline event" do
      post_json("/api/hooks", "spec/fixture/gitlab/webhooks/pipeline.json")

      aggregate_failures do
        expect(last_response.status).to eq(202)
        expect(last_response.body).to eq({}.to_json)
        expect(Webhooks::PipelineEventHandler).to have_received(:call).with(
          "merge_request_event",
          "success",
          "dependabot-gitlab/test",
          1,
          "can_be_merged"
        )
      end
    end
  end

  context "with unsuccessful response" do
    let(:error) { StandardError.new("Unexpected") }
    let(:auth_token) { "auth_token" }

    before do
      allow(CredentialsConfig).to receive(:gitlab_auth_token) { auth_token }
      allow(Webhooks::PushEventHandler).to receive(:call).and_raise(error)
      allow(Sentry).to receive(:capture_exception)
    end

    it "system error" do
      post_json("/api/hooks", "spec/fixture/gitlab/webhooks/push.json", auth_token)

      aggregate_failures do
        expect(Sentry).to have_received(:capture_exception).with(error)
        expect(last_response.status).to eq(500)
        expect(last_response.body).to eq({ status: 500, error: "Unexpected" }.to_json)
      end
    end

    it "invalid request" do
      post_json("/api/hooks", { "funky" => "object" }, auth_token)

      aggregate_failures do
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq(
          { status: 400, error: "Unsupported or missing parameter 'object_kind'" }.to_json
        )
      end
    end

    it "unauthorized request" do
      post_json("/api/hooks", "spec/fixture/gitlab/webhooks/push.json", "invalid_token")

      aggregate_failures do
        expect(last_response.status).to eq(401)
        expect(last_response.body).to eq({ status: 401, error: "Invalid gitlab authentication token" }.to_json)
      end
    end
  end
end
