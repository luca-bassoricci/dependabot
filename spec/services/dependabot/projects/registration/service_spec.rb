# frozen_string_literal: true

describe Dependabot::Projects::Registration::Service, integration: true, epic: :services, feature: :dependabot do
  subject(:sync) { described_class }

  let(:gitlab) { instance_double("Gitlab::Client", projects: projects_response) }
  let(:projects_response) { instance_double("Gitlab::PaginatedResponse") }

  let(:config_yaml) do
    <<~YAML
      version: 2
      updates:
        - package-ecosystem: bundler
          directory: "/"
          schedule:
            interval: daily
            time: "01:00"
        - package-ecosystem: npm
          directory: "/"
          schedule:
            interval: daily
            time: "01:00"
    YAML
  end

  let(:cron) { "00 01 * * * UTC" }
  let(:default_branch) { "main" }

  let(:project) { build(:project, config_yaml: config_yaml) }

  let(:gitlab_project) do
    Gitlab::ObjectifiedHash.new(
      id: project.id,
      path_with_namespace: project.name,
      default_branch: default_branch
    )
  end

  let(:jobs) do
    [
      Sidekiq::Cron::Job.new(name: "#{project.name}:bundler:/", cron: cron),
      Sidekiq::Cron::Job.new(name: "#{project.name}:npm:/", cron: cron)
    ]
  end

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
    allow(projects_response).to receive(:auto_paginate).and_yield(gitlab_project)
    allow(Dependabot::Projects::Creator).to receive(:call).with(gitlab_project.path_with_namespace) { project }
    allow(Cron::JobSync).to receive(:call).with(project)

    allow(Dependabot::Config::Fetcher).to receive(:call)
      .with(
        gitlab_project.path_with_namespace,
        branch: gitlab_project.default_branch,
        update_cache: true
      )
      .and_return(project.configuration)
  end

  context "with ignored project" do
    before do
      allow(AppConfig).to receive(:project_registration_namespace).and_return("test")
    end

    it "skips project" do
      sync.call

      expect(Dependabot::Config::Fetcher).not_to have_received(:call)
    end
  end

  context "with non existing project", :aggregate_failures do
    context "without configuration" do
      before do
        allow(Dependabot::Config::Fetcher).to receive(:call).and_raise(Dependabot::Config::MissingConfigurationError)
      end

      it "skips registering project" do
        sync.call

        expect(Dependabot::Projects::Creator).not_to have_received(:call).with(project.name)
        expect(Cron::JobSync).not_to have_received(:call).with(project)
      end
    end

    context "with configuration" do
      it "registers project" do
        sync.call

        expect(Dependabot::Projects::Creator).to have_received(:call).with(project.name)
        expect(Cron::JobSync).to have_received(:call).with(project)
      end
    end

    context "without default_branch" do
      let(:default_branch) { nil }

      it "skips project" do
        sync.call

        expect(Dependabot::Projects::Creator).not_to have_received(:call)
      end
    end
  end

  context "with existing project" do
    let(:project) { create(:project, config_yaml: config_yaml) }

    context "without config" do
      before do
        allow(Dependabot::Config::Fetcher).to receive(:call).and_raise(Dependabot::Config::MissingConfigurationError)
        allow(Dependabot::Projects::Remover).to receive(:call).with(project.name)
      end

      it "removes project" do
        sync.call

        expect(Dependabot::Projects::Remover).to have_received(:call).with(project.name)
      end
    end

    context "with out of sync jobs", :aggregate_failures do
      before do
        allow(Sidekiq::Cron::Job).to receive(:all).and_return([jobs[0]])
      end

      it "syncs project and jobs" do
        sync.call

        expect(Dependabot::Projects::Creator).to have_received(:call).with(project.name)
        expect(Cron::JobSync).to have_received(:call).with(project)
      end
    end

    context "with jobs in sync", :aggregate_failures do
      before do
        allow(Sidekiq::Cron::Job).to receive(:all).and_return(jobs)
      end

      it "skips project" do
        sync.call

        expect(Dependabot::Projects::Creator).not_to have_received(:call).with(project.name)
        expect(Cron::JobSync).not_to have_received(:call).with(project)
      end
    end

    context "with renamed project", :aggregate_failures do
      let!(:old_name) { project.name }
      let!(:new_name) { Faker::Alphanumeric.unique.alpha(number: 15) }

      let(:gitlab_project) do
        Gitlab::ObjectifiedHash.new(
          id: project.id,
          path_with_namespace: new_name,
          default_branch: default_branch
        )
      end

      before do
        allow(Cron::JobRemover).to receive(:call)
      end

      it "renames existing project" do
        sync.call

        expect(project.reload.name).to eq(new_name)
        expect(Cron::JobRemover).to have_received(:call).with(old_name)
        expect(Cron::JobSync).to have_received(:call).with(project)
      end
    end
  end
end
