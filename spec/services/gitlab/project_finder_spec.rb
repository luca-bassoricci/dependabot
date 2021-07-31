# frozen_string_literal: true

describe Gitlab::ProjectFinder, integration: true, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", projects: projects) }

  let(:existing_project) { OpenStruct.new(path_with_namespace: random_name, default_branch: "main") }
  let(:no_config_project) { OpenStruct.new(path_with_namespace: random_name, default_branch: "main") }
  let(:new_project) { OpenStruct.new(path_with_namespace: random_name, default_branch: "main") }
  let(:projects) { [existing_project, no_config_project, new_project] }

  def random_name
    Faker::Alphanumeric.unique.alpha(number: 15)
  end

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }

    allow(Gitlab::Config::Checker).to receive(:call)
      .with(existing_project.path_with_namespace, existing_project.default_branch)
      .and_return(true)
    allow(Gitlab::Config::Checker).to receive(:call)
      .with(no_config_project.path_with_namespace, no_config_project.default_branch)
      .and_return(false)
    allow(Gitlab::Config::Checker).to receive(:call)
      .with(new_project.path_with_namespace, new_project.default_branch)
      .and_return(true)

    Project.new(name: existing_project.path_with_namespace).save!
  end

  it "returns unregistered projects with present configuration" do
    expect(described_class.call).to eq([new_project.path_with_namespace])
    expect(gitlab).to have_received(:projects).with(min_access_level: 30)
  end
end
