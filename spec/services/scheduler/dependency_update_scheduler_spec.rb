# frozen_string_literal: true

describe Scheduler::DependencyUpdateScheduler do
  include_context "with dependabot helper"

  let(:project) { Project.new(name: repo, config: config) }
  let(:config) do
    [
      *dependabot_config,
      {
        package_manager: "docker",
        package_ecosystem: "docker",
        directory: "/",
        cron: "00 02 * * sun Europe/Riga"
      }
    ]
  end
  let(:jobs) do
    config.map do |conf|
      package_ecosystem = conf[:package_ecosystem]
      directory = conf[:directory]

      Sidekiq::Cron::Job.new(
        name: "#{repo}:#{package_ecosystem}:#{directory}",
        cron: conf[:cron],
        class: "DependencyUpdateJob",
        args: { "repo" => repo, "package_ecosystem" => package_ecosystem, "directory" => directory },
        active_job: true,
        description: "Update #{package_ecosystem} dependencies for #{repo} in #{directory}"
      )
    end
  end

  before do
    allow(Rails.logger).to receive(:error)

    project.save!
  end

  context "with valid configuration" do
    it "creates and enques jobs" do
      described_class.call(project)

      aggregate_failures do
        expect(Sidekiq::Cron::Job.all.count { |job| job.name.include?(repo) }).to eq(2)
      end
    end
  end

  context "with changed configuration" do
    let(:modified_config) { config.dup.tap(&:pop) }

    before do
      jobs.each(&:save)
      project.update_attributes!(config: modified_config)
    end

    it "removes non existing job" do
      described_class.call(project)

      aggregate_failures do
        expect(Sidekiq::Cron::Job.all.count { |job| job.name.include?(repo) }).to eq(1)
      end
    end
  end

  context "with invalid config" do
    let(:invalid_config) { config.dup.tap { |conf| conf[1].delete(:cron) } }

    before do
      project.update_attributes!(config: invalid_config)
    end

    it "logs job error" do
      described_class.call(project)

      expect(Rails.logger).to have_received(:error).once
    end
  end
end
