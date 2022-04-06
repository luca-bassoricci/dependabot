# frozen_string_literal: true

describe Webhooks::SystemHookHandler, integration: true, epic: :services, feature: :webhooks do
  subject(:result) do
    described_class.call(
      event_name: event,
      project_name: project.name,
      old_project_name: old_project_name
    )
  end

  let(:project) { build(:project) }
  let(:old_project_name) { nil }

  before do
    allow(Cron::JobRemover).to receive(:call)
    allow(Cron::JobSync).to receive(:call)
  end

  context "with project_create event", :aggregate_failures do
    let(:event) { "project_create" }

    before do
      allow(Dependabot::Projects::Creator).to receive(:call) { project }
    end

    it "creates new project" do
      expect(result).to eq(project.to_hash)

      expect(Dependabot::Projects::Creator).to have_received(:call).with(project.name)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end
  end

  context "with project_destroy event", :aggregate_failures do
    let(:event) { "project_destroy" }

    context "with existing project" do
      let(:project) { create(:project) }

      it "removes project" do
        expect(result).to eq("project removed successfully")

        expect(Project.where(name: project.name).first).to be_nil
        expect(Cron::JobRemover).to have_received(:call).with(project.name)
      end
    end

    context "without existing project" do
      let(:project) { build(:project) }

      it "returns nil" do
        expect(result).to be_nil
      end
    end
  end

  RSpec.shared_examples "project rename event" do
    let(:old_project_name) { Faker::Alphanumeric.unique.alpha(number: 15) }

    context "with existing project", :aggregate_failures do
      let(:project) { create(:project, name: old_project_name) }

      it "updates existing project" do
        expect(result).to eq("project updated to #{project.name}")
        expect(project.reload.name).to eq(project.name)
        expect(Cron::JobRemover).to have_received(:call).with(old_project_name)
        expect(Cron::JobSync).to have_received(:call).with(project)
      end
    end

    context "without existing project", :aggregate_failures do
      let(:project) { build(:project) }

      it "returns nil" do
        expect(result).to be_nil
      end
    end
  end

  context "with project_rename event" do
    let(:event) { "project_rename" }

    it_behaves_like "project rename event"
  end

  context "with project_transfer event" do
    let(:event) { "project_transfer" }

    it_behaves_like "project rename event"
  end
end
