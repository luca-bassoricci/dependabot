# frozen_string_literal: true

describe "rake", epic: :tasks do # rubocop:disable RSpec/DescribeClass
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
        "project_name" => args[:project],
        "package_ecosystem" => args[:package_ecosystem],
        "directory" => args[:directory]
      )
    end

    it "raises error on blank argument" do
      expect { task.invoke(*args.values[0..1]) }.to(
        raise_error(ArgumentError, "[:directory] must not be blank")
      )
    end
  end

  describe "dependabot:register", integration: true do
    let(:project_name) { "test-project" }
    let(:project) { Project.new(name: project_name) }

    before do
      allow(Dependabot::ProjectCreator).to receive(:call) { project }
      allow(Cron::JobSync).to receive(:call).with(project).and_call_original
    end

    it "registers new project" do
      task.invoke(project_name)

      expect(Dependabot::ProjectCreator).to have_received(:call).with(project_name)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end
  end

  describe "dependabot:remove", integration: true do
    let(:project_name) { "test-project" }

    before do
      allow(Dependabot::ProjectRemover).to receive(:call)
    end

    it "removes project" do
      task.invoke(project_name)

      expect(Dependabot::ProjectRemover).to have_received(:call).with(project_name)
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
        expect { task.invoke }.not_to raise_error
      end
    end

    context "without sidekiq processing job" do
      let(:task_name) { "dependabot:check_sidekiq" }
      let(:healthcheck_return) { true }

      it "fails" do
        expect { task.invoke }.to raise_error(SystemExit)
      end
    end
  end

  # rubocop:disable RSpec/MessageChain
  describe "dependabot:check_db" do
    before do
      allow(Mongoid).to receive_message_chain("client.database_names.present?")
    end

    it "passes successfully" do
      expect { task.invoke }.not_to raise_error
    end
  end

  describe "dependabot:check_redis" do
    before do
      allow(Redis).to receive_message_chain("new.ping")
    end

    it "passes successfully" do
      expect { task.invoke }.not_to raise_error
    end
  end
  # rubocop:enable RSpec/MessageChain
end
