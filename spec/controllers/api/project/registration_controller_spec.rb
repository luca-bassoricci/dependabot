# frozen_string_literal: true

RSpec.shared_examples "registration controller" do
  it "handles event" do
    post_json("/api/project/registration", { event_name: event_name, **request_args })

    aggregate_failures do
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("success")
      expect(Webhooks::SystemHookHandler).to have_received(:call).with(**handler_args)
    end
  end
end

describe Api::Project::RegistrationController, epic: :controllers do
  include_context "with rack_test"

  let(:project_name) { "project-name" }
  let(:old_project_name) { "old-project-name" }

  let(:request_args) { { path_with_namespace: project_name } }
  let(:handler_args) { { event_name: event_name, project_name: project_name, old_project_name: nil } }

  before do
    allow(Webhooks::SystemHookHandler).to receive(:call).and_return("success")
  end

  context "with project namespace filter" do
    let(:event_name) { "project_create" }
    let(:project_name) { "namespace_1/project-name" }

    before do
      allow(AppConfig).to receive(:project_registration_namespace).and_return("allowed-namespace")
    end

    it "does not register project from not allowed namespace" do
      post_json("/api/project/registration", { event_name: event_name, **request_args })

      aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq("Skipped, does not match allowed namespace pattern")
      end
    end
  end

  context "with project_create event" do
    let(:event_name) { "project_create" }

    it_behaves_like "registration controller"
  end

  context "with project_destroy event" do
    let(:event_name) { "project_destroy" }

    it_behaves_like "registration controller"
  end

  context "with project_rename event" do
    let(:event_name) { "project_rename" }
    let(:request_args) { { path_with_namespace: project_name, old_path_with_namespace: old_project_name } }
    let(:handler_args) { { event_name: event_name, project_name: project_name, old_project_name: old_project_name } }

    it_behaves_like "registration controller"
  end

  context "with project_transfer event" do
    let(:event_name) { "project_transfer" }
    let(:request_args) { { path_with_namespace: project_name, old_path_with_namespace: old_project_name } }
    let(:handler_args) { { event_name: event_name, project_name: project_name, old_project_name: old_project_name } }

    it_behaves_like "registration controller"
  end

  context "with unsuccessful response" do
    let(:error) { StandardError.new("Unexpected") }
    let(:auth_token) { "auth_token" }

    before do
      allow(Webhooks::SystemHookHandler).to receive(:call).and_raise(error)
    end

    it "handles invalid request" do
      post_json("/api/project/registration", { "funky" => "object" })

      aggregate_failures do
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq(
          { status: 400, error: "Unsupported event or missing parameter 'event_name'" }.to_json
        )
      end
    end

    it "handles unsupported event" do
      post_json("/api/project/registration", { event_name: "not_supported" })

      aggregate_failures do
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq(
          { status: 400, error: "Unsupported event or missing parameter 'event_name'" }.to_json
        )
      end
    end
  end
end
