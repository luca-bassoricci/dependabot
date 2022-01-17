# frozen_string_literal: true

describe Dependabot::Projects::Sync, integration: true, epic: :services, feature: :dependabot do
  subject(:sync) { described_class }

  let(:gitlab) do
    instance_double(
      "Gitlab::Client",
      projects: instance_double("Gitlab::PaginatedResponse", auto_paginate: projects)
    )
  end

  let(:cron) { "0 1 * * * UTC" }
  let(:project_name) { random_name }
  let(:project) { Gitlab::ObjectifiedHash.new(path_with_namespace: project_name, default_branch: "main") }
  let(:projects) { [project] }
  let(:config) do
    [
      {
        package_ecosystem: "npm",
        directory: "/",
        cron: cron
      },
      {
        package_ecosystem: "bundler",
        directory: "/",
        cron: cron
      }
    ]
  end
  let(:jobs) do
    [
      Sidekiq::Cron::Job.new(name: "#{project_name}:bundler:/", cron: cron),
      Sidekiq::Cron::Job.new(name: "#{project_name}:npm:/", cron: cron)
    ]
  end

  let(:saved_project) { Project.new(name: project_name) }

  def random_name
    Faker::Alphanumeric.unique.alpha(number: 15)
  end

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }

    allow(Dependabot::Config::Fetcher).to receive(:call).with(
      project.path_with_namespace, branch: project.default_branch, update_cache: true
    ).and_return(config)
    allow(Dependabot::Projects::Creator).to receive(:call).with(project.path_with_namespace) { saved_project }
    allow(Cron::JobSync).to receive(:call).with(saved_project)
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

  context "with non existing project" do
    context "without configuration" do
      before do
        allow(Dependabot::Config::Fetcher).to receive(:call).and_raise(Dependabot::Config::MissingConfigurationError)
      end

      it "skips registering project" do
        sync.call

        aggregate_failures do
          expect(Dependabot::Projects::Creator).not_to have_received(:call).with(project_name)
          expect(Cron::JobSync).not_to have_received(:call).with(saved_project)
        end
      end
    end

    context "with configuration" do
      it "registers project" do
        sync.call

        aggregate_failures do
          expect(Dependabot::Projects::Creator).to have_received(:call).with(project_name)
          expect(Cron::JobSync).to have_received(:call).with(saved_project)
        end
      end
    end
  end

  context "with existing project" do
    before do
      saved_project.save!
    end

    context "without config" do
      before do
        allow(Dependabot::Config::Fetcher).to receive(:call).and_raise(Dependabot::Config::MissingConfigurationError)
        allow(Dependabot::Projects::Remover).to receive(:call).with(project_name)
      end

      it "removes project" do
        sync.call

        expect(Dependabot::Projects::Remover).to have_received(:call).with(project_name)
      end
    end

    context "with out of sync jobs" do
      before do
        allow(Sidekiq::Cron::Job).to receive(:all).and_return([jobs[0]])
      end

      it "syncs project and jobs" do
        sync.call

        aggregate_failures do
          expect(Dependabot::Projects::Creator).to have_received(:call).with(project_name)
          expect(Cron::JobSync).to have_received(:call).with(saved_project)
        end
      end
    end

    context "with jobs in sync" do
      before do
        allow(Sidekiq::Cron::Job).to receive(:all).and_return(jobs)
      end

      it "skips project" do
        sync.call

        aggregate_failures do
          expect(Dependabot::Projects::Creator).not_to have_received(:call).with(project_name)
          expect(Cron::JobSync).not_to have_received(:call).with(saved_project)
        end
      end
    end
  end
end
