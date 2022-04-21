# frozen_string_literal: true

describe Github::Vulnerabilities::UpdateJobCreator, epic: :services, feature: :github do
  let(:ecosystems) do
    %w[bundler composer gomod gradle maven npm pip nuget]
  end

  let(:cron_create_args) do
    ecosystems.each_with_index.map do |ecosystem, index|
      {
        name: "#{ecosystem} vulnerability sync",
        cron: "0 #{index + 1}/12 * * *",
        args: ecosystem,
        class: "SecurityVulnerabilityUpdateJob",
        description: "Update security vulnerabilities for #{ecosystem}",
        active_job: true
      }
    end
  end

  before do
    allow(Sidekiq::Cron::Job).to receive(:create)
  end

  context "with configured github access token" do
    around do |example|
      with_env("SETTINGS__GITHUB_ACCESS_TOKEN" => "token") { example.run }
    end

    context "without already created jobs" do
      before do
        allow(Sidekiq::Cron::Job).to receive(:find).and_return(nil)
      end

      it "creates jobs for vulnerability database updates", :aggregate_failures do
        described_class.call

        cron_create_args.each do |args|
          expect(Sidekiq::Cron::Job).to have_received(:create).with(args)
        end
      end
    end

    context "with already created jobs" do
      before do
        allow(Sidekiq::Cron::Job).to receive(:find).and_return("job")
      end

      it "skips jobs creation", :aggregate_failures do
        described_class.call

        expect(Sidekiq::Cron::Job).not_to have_received(:create)
      end
    end
  end

  context "without configured github access token" do
    let(:job_name) { "nuget vulnerability sync" }

    around do |example|
      with_env("SETTINGS__GITHUB_ACCESS_TOKEN" => nil) { example.run }
    end

    before do
      allow(Sidekiq::Cron::Job).to receive(:destroy)
      allow(Sidekiq::Cron::Job).to receive(:find).with(kind_of(String)).and_return(nil)
      allow(Sidekiq::Cron::Job).to receive(:find).with(job_name).and_return("job")
    end

    it "does not create jobs for package system vulnerability update", :aggregate_failures do
      described_class.call

      expect(Sidekiq::Cron::Job).not_to have_received(:create)
      expect(Sidekiq::Cron::Job).to have_received(:destroy).with(job_name)
    end
  end
end
