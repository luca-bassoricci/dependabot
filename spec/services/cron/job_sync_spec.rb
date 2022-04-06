# frozen_string_literal: true

describe Cron::JobSync, integration: true, epic: :services, feature: :cron do
  let(:project) { create(:project, config_yaml: config_yaml) }
  let(:config) { project.configuration.updates }
  let(:cron_job_transformer) { ->(job) { { name: job.name, args: job.args, cron: job.cron } } }

  let(:config_yaml) do
    <<~YAML
      version: 2
      updates:
        - package-ecosystem: bundler
          directory: "/"
          schedule:
            interval: daily
            time: "02:00"
        - package-ecosystem: docker
          directory: "/"
          schedule:
            interval: daily
            time: "02:00"
        - package-ecosystem: npm
          directory: "/"
          schedule:
            interval: daily
            time: "02:00"
    YAML
  end

  let(:cron_jobs) do
    config.map do |conf|
      package_ecosystem = conf[:package_ecosystem]
      directory = conf[:directory]

      Sidekiq::Cron::Job.new(
        name: "#{project.name}:#{package_ecosystem}:#{directory}",
        cron: conf[:cron],
        class: "DependencyUpdateJob",
        args: { "project_name" => project.name, "package_ecosystem" => package_ecosystem, "directory" => directory },
        active_job: true,
        description: "Update #{package_ecosystem} dependencies for #{project.name} in #{directory}"
      )
    end
  end

  let(:actual_cron_jobs) do
    Sidekiq::Cron::Job.all
                      .select { |job| job.name.include?(project.name) }
                      .map(&cron_job_transformer)
  end

  context "with new configuration", :aggregate_failures do
    it "creates jobs" do
      expected_jobs = project.update_jobs.all.map { |job| [job.package_ecosystem, job.directory, job.cron] }
      project.update_jobs.destroy

      actual_jobs = described_class.call(project).map { |job| [job.package_ecosystem, job.directory, job.cron] }

      expect(actual_cron_jobs).to match_array(cron_jobs.map(&cron_job_transformer))
      expect(actual_jobs).to eq(expected_jobs)
    end
  end

  context "with changed configuration", :aggregate_failures do
    let(:modified_config) { config.dup.tap(&:pop) }

    before do
      cron_jobs.each(&:save)
      project.configuration.update_attributes!(updates: modified_config)
    end

    it "removes non existing job" do
      actual_jobs = described_class.call(project)

      expect(actual_cron_jobs).to match_array(cron_jobs[0..1].map(&cron_job_transformer))
      expect(actual_jobs.to_a).to eq(project.update_jobs.to_a[0..1])
    end
  end
end
