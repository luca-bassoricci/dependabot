# frozen_string_literal: true

describe "rake", epic: :tasks do # rubocop:disable RSpec/DescribeClass
  include_context "with rake helper"

  describe "dependabot:update" do
    let(:errors) { [] }
    let(:args) do
      {
        project: "test-repo",
        package_ecosystem: "bundler",
        directory: "/"
      }
    end

    before do
      allow(DependencyUpdateJob).to receive(:perform_now).and_return(errors)
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
      expect { task.invoke(*args.values[0..1]) }.to raise_error(SystemExit)
    end

    context "with errors in dependency updates" do
      let(:errors) { ["Some error!"] }
      let(:task_name) { "dependabot:update" }

      it "exits with non 0 result code" do
        expect { task.invoke(*args.values) }.to raise_error(SystemExit)
      end
    end
  end

  describe "dependabot:register", integration: true do
    let(:project_name) { "test-project" }
    let(:project) { Project.new(name: project_name) }

    before do
      allow(Dependabot::Projects::Creator).to receive(:call) { project }
      allow(Cron::JobSync).to receive(:call).with(project).and_call_original
    end

    it "registers new project" do
      task.invoke(project_name)

      expect(Dependabot::Projects::Creator).to have_received(:call).with(project_name)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end
  end

  describe "dependabot:remove", integration: true do
    let(:project_name) { "test-project" }

    before do
      allow(Dependabot::Projects::Remover).to receive(:call)
    end

    it "removes project" do
      task.invoke(project_name)

      expect(Dependabot::Projects::Remover).to have_received(:call).with(project_name)
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
    let(:redis) { instance_double("Redis", ping: "PONG", close: nil) }

    before do
      allow(Redis).to receive(:new).and_return(redis)
    end

    it "passes successfully" do
      expect { task.invoke }.not_to raise_error
    end
  end
  # rubocop:enable RSpec/MessageChain
end
