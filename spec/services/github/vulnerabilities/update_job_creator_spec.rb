# frozen_string_literal: true

describe Github::Vulnerabilities::UpdateJobCreator, epic: :services, feature: :github do
  let(:cron_create_args) do
    {
      name: "Vulnerability database sync",
      cron: "0 1/12 * * *",
      class: "SecurityVulnerabilityUpdateJob",
      description: "Vulnerability database update",
      active_job: true
    }
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

        expect(Sidekiq::Cron::Job).to have_received(:create).with(cron_create_args)
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
    let(:job_name) { cron_create_args[:name] }

    around do |example|
      with_env("SETTINGS__GITHUB_ACCESS_TOKEN" => nil) { example.run }
    end

    before do
      allow(Sidekiq::Cron::Job).to receive(:destroy)
      allow(Sidekiq::Cron::Job).to receive(:find).with(job_name).and_return("job")
    end

    it "does not create jobs for package system vulnerability update", :aggregate_failures do
      described_class.call

      expect(Sidekiq::Cron::Job).not_to have_received(:create)
      expect(Sidekiq::Cron::Job).to have_received(:destroy).with(job_name)
    end
  end
end
