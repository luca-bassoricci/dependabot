# frozen_string_literal: true

describe Scheduler::DependencyUpdateScheduler do
  include_context "dependabot"

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

  subject { described_class }

  before do
    allow(Gitlab::ConfigFetcher).to receive(:call).with(repo).and_return(raw_config)
    allow(Configuration::Parser).to receive(:call).with(raw_config).and_return(config)
    allow(Rails.logger).to receive(:error)
  end

  context "valid configuration" do
    it "persists projects and enques jobs" do
      subject.call(repo)

      aggregate_failures do
        expect(Project.where(name: repo).count).to eq(1)
        expect(Sidekiq::Cron::Job.all.count { |job| job.name.include?(repo) }).to eq(2)
      end
    end
  end

  context "changed configuration" do
    let(:modified_config) { config.dup.tap(&:pop) }

    before do
      allow(Configuration::Parser).to receive(:call) { modified_config }

      jobs.each(&:save)
      Project.create!(name: repo, config: config)
    end

    it "updates project and removes job" do
      subject.call(repo)

      aggregate_failures do
        expect(Sidekiq::Cron::Job.all.count { |job| job.name.include?(repo) }).to eq(1)
        expect(Project.where(name: repo).first.config.size).to eq(1)
      end
    end
  end

  context "logs job error" do
    let(:invalid_config) { config.dup.tap { |conf| conf[1].delete(:cron) } }

    before do
      allow(Configuration::Parser).to receive(:call) { invalid_config }
    end

    it "on invalid config" do
      subject.call(repo)

      expect(Rails.logger).to have_received(:error).once
    end
  end
end
