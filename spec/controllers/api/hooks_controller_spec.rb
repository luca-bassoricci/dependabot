# frozen_string_literal: true

describe Api::HooksController, :aggregate_failures, type: :request, epic: :controllers, feature: :api, story: :hooks do
  subject(:receive_webhook) { post_json("/api/hooks", body, auth_token) }

  include_context "with api helper"

  let(:auth_token) { "auth_token" }

  before do
    allow(CredentialsConfig).to receive(:gitlab_auth_token) { auth_token }
  end

  context "with successful response" do
    let(:project) { Project.new(name: "mike/diaspora", configuration: Configuration.new) }
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
      allow(Webhooks::PushEventHandler).to receive(:call) { project.to_hash }
      allow(Webhooks::MergeRequestEventHandler).to receive(:call).and_return({ closed_merge_request: true })
      allow(Webhooks::CommentEventHandler).to receive(:call).and_return(nil)
      allow(Webhooks::PipelineEventHandler).to receive(:call).and_return(nil)
    end

    def params(object)
      ActionController::Parameters.new(object).permit!
    end

    context "with push event" do
      let(:body) { hash("spec/fixture/gitlab/webhooks/push.json") }

      it "handles event" do
        receive_webhook

        expect_status(200)
        expect_json(project.to_hash)
        expect(Webhooks::PushEventHandler).to have_received(:call).with(
          project_name: project.name,
          commits: body[:commits].map { |it| params(it.slice(:added, :modified, :removed)) }
        )
      end
    end

    context "with mr event" do
      let(:body) { hash("spec/fixture/gitlab/webhooks/mr_close.json") }

      it "handles event" do
        receive_webhook

        expect_status(200)
        expect_json({ closed_merge_request: true })
        expect(Webhooks::MergeRequestEventHandler).to have_received(:call).with(
          project_name: "dependabot-gitlab/test",
          mr_iid: "69",
          action: "close",
          merge_status: "can_be_merged"
        )
      end
    end

    context "with comment event" do
      let(:body) { hash("spec/fixture/gitlab/webhooks/comment.json") }

      it "comment event" do
        receive_webhook

        expect_status(202)
        expect_json({})
        expect(Webhooks::CommentEventHandler).to have_received(:call).with(
          discussion_id: body.dig(:object_attributes, :discussion_id),
          note: body.dig(:object_attributes, :note),
          project_name: body.dig(:project, :path_with_namespace),
          mr_iid: body.dig(:merge_request, :iid).to_s
        )
      end
    end

    context "with pipeline event" do
      let(:body) { hash("spec/fixture/gitlab/webhooks/pipeline.json") }

      it "pipeline event" do
        receive_webhook

        expect_status(202)
        expect_json({})
        expect(Webhooks::PipelineEventHandler).to have_received(:call).with(
          source: body.dig(:object_attributes, :source),
          status: body.dig(:object_attributes, :status),
          project_name: body.dig(:project, :path_with_namespace),
          mr_iid: body.dig(:merge_request, :iid).to_s,
          merge_status: body.dig(:merge_request, :merge_status),
          source_project_id: body.dig(:merge_request, :source_project_id).to_s,
          target_project_id: body.dig(:merge_request, :target_project_id).to_s
        )
      end
    end
  end

  context "with unsuccessful response" do
    let(:error) { StandardError.new("Unexpected") }

    before do
      allow(Sentry).to receive(:capture_exception)
    end

    context "with system error" do
      let(:body) { hash("spec/fixture/gitlab/webhooks/push.json") }

      before do
        allow(Webhooks::PushEventHandler).to receive(:call).and_raise(error)
      end

      it "returns 500" do
        receive_webhook

        expect_status(500)
        expect_json({ status: 500, error: "Unexpected" })
        expect(Sentry).to have_received(:capture_exception).with(error)
      end
    end

    context "with invalid request" do
      let(:body) { { "funky" => "object" } }

      it "returns 400" do
        receive_webhook

        expect_status(400)
        expect_json({ status: 400, error: "Unsupported or missing parameter 'object_kind'" })
      end
    end

    context "with unauthorized request" do
      let(:body) { hash("spec/fixture/gitlab/webhooks/push.json") }

      it "returns 401" do
        post_json("/api/hooks", body, "wrong_token")

        expect_status(401)
        expect_json({ status: 401, error: "Invalid gitlab authentication token" })
      end
    end
  end
end
