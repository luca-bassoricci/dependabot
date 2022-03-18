# frozen_string_literal: true

describe Cron::JobSync, integration: true, epic: :services, feature: :cron do
  include_context "with dependabot helper"

  let(:project) { Project.new(name: repo, configuration: Configuration.new(updates: config)) }

  let(:config) do
    [
      *updates_config,
      {
        package_ecosystem: "docker",
        directory: "/",
        cron: "00 02 * * sun Europe/Riga"
      },
      {
        package_ecosystem: "npm",
        directory: "/npm",
        cron: "00 02 * * sun Europe/Riga"
      }
    ]
  end

  let(:cron_jobs) do
    config.map do |conf|
      package_ecosystem = conf[:package_ecosystem]
      directory = conf[:directory]

      Sidekiq::Cron::Job.new(
        name: "#{repo}:#{package_ecosystem}:#{directory}",
        cron: conf[:cron],
        class: "DependencyUpdateJob",
        args: { "project_name" => repo, "package_ecosystem" => package_ecosystem, "directory" => directory },
        active_job: true,
        description: "Update #{package_ecosystem} dependencies for #{repo} in #{directory}"
      )
    end
  end

  let(:jobs) do
    config.map do |conf|
      package_ecosystem = conf[:package_ecosystem]
      directory = conf[:directory]

      UpdateJob.new(
        project_id: project._id,
        package_ecosystem: package_ecosystem,
        directory: directory,
        cron: conf[:cron]
      )
    end
  end

  before do
    project.save!
  end

  context "with new configuration", :aggregate_failures do
    it "creates jobs" do
      described_class.call(project)

      expect(Sidekiq::Cron::Job.all.count { |job| job.name.include?(repo) }).to eq(3)
      expect(project.update_jobs.size).to eq(3)
    end
  end

  context "with changed configuration", :aggregate_failures do
    let(:modified_config) { config.dup.tap(&:pop) }

    before do
      jobs.each(&:save!)
      cron_jobs.each(&:save)
      project.configuration.update_attributes!(updates: modified_config)
    end

    it "removes non existing job" do
      described_class.call(project)

      cron_args_mapper = ->(job) { { name: job.name, args: job.args, cron: job.cron } }
      expected_persisted_job = project.update_jobs.to_a
      # can't compare sidekiq cron job objects directly
      expected_cron_jobs = Sidekiq::Cron::Job.all
                                             .select { |job| cron_jobs[0..1].any? { |jb| jb.name == job.name } }
                                             .map(&cron_args_mapper)

      expect(expected_cron_jobs).to match_array(cron_jobs[0..1].map(&cron_args_mapper))
      expect(expected_persisted_job).to match_array(jobs[0..1])
    end
  end
end
