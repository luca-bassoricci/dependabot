# frozen_string_literal: true

describe "rake" do # rubocop:disable RSpec/DescribeClass
  include_context "with rake helper"

  describe "dependabot:update" do
    let(:args) do
      {
        project: "test-repo",
        package_ecosystem: "bundler",
        directory: "/"
      }
    end

    before do
      allow(DependencyUpdateJob).to receive(:perform_now)
    end

    it "runs updates for project" do
      task.invoke(*args.values)

      expect(DependencyUpdateJob).to have_received(:perform_now).with(
        "repo" => args[:project],
        "package_ecosystem" => args[:package_ecosystem],
        "directory" => args[:directory]
      )
    end
  end

  describe "dependabot:register" do
    let(:project_name) { "test-project" }
    let(:project) { Project.new(name: project_name, config: []) }

    before do
      allow(Dependabot::ProjectCreator).to receive(:call) { project }
      allow(Cron::JobSync).to receive(:call)
    end

    it "registers new project" do
      task.invoke(project_name)

      expect(Dependabot::ProjectCreator).to have_received(:call).with(project_name)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end
  end

  describe "dependabot:check_sidekiq" do
    before do
      allow(Sidekiq).to receive(:configure_client)
      allow(Sidekiq::ProcessSet).to receive(:new).and_return([1])
      allow(HealthcheckJob).to receive(:perform_later) { healthcheck_return }
    end

    context "with sidekiq processing job" do
      let(:task_name) { "dependabot:check_sidekiq" }
      let(:healthcheck_return) { FileUtils.touch(HealthcheckConfig.filename) }

      it "passes successfully" do
        expect { task.execute }.not_to raise_error
      end
    end

    context "without sidekiq processing job" do
      let(:task_name) { "dependabot:check_sidekiq" }
      let(:healthcheck_return) { true }

      it "fails" do
        expect { task.execute }.to raise_error(SystemExit)
      end
    end
  end
end
