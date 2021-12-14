# frozen_string_literal: true

RSpec.shared_examples "registration controller" do
  it "handles event", :aggregate_failures do
    post_json(path, { event_name: event_name, **request_args })

    expect_status(200)
    expect_json(message: "success")
    expect(Webhooks::SystemHookHandler).to have_received(:call).with(**handler_args)
  end
end

describe Api::RegistrationController, epic: :controllers do
  include_context "with api helper"

  let(:path) { "/api/projects/registration" }

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

    it "does not register project from not allowed namespace", :aggregate_failures do
      post_json(path, { event_name: event_name, **request_args })

      expect_status(202)
      expect_json(message: "Skipped, does not match allowed namespace pattern")
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
      post_json(path, { "funky" => "object" })

      expect_status(400)
      expect_json(status: 400, error: "Unsupported event or missing parameter 'event_name'")
    end

    it "handles unsupported event" do
      post_json(path, { event_name: "not_supported" })

      expect_status(400)
      expect_json(status: 400, error: "Unsupported event or missing parameter 'event_name'")
    end
  end
end
