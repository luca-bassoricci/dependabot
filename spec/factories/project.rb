# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    transient do
      config_yaml do
        <<~YAML
          version: 2
          registries:
            dockerhub:
              type: docker-registry
              url: registry.hub.docker.com
              username: octocat
              password: password
          updates:
            - package-ecosystem: bundler
              directory: "/"
              schedule:
                interval: weekly
        YAML
      end
    end

    id { Faker::Number.number(digits: 10) }
    name { Faker::Alphanumeric.unique.alpha(number: 15) }
    web_url { "#{AppConfig.gitlab_url}/#{name}" }

    configuration { association :configuration, strategy: :build, project_name: name, config_yaml: config_yaml }

    after(:build) do |project, _evaluator|
      project.configuration.updates.each do |conf|
        build(
          :update_job,
          project: project,
          package_ecosystem: conf[:package_ecosystem],
          directory: conf[:directory],
          cron: conf[:cron]
        )
      end
    end

    after(:create) do |project, _evaluator|
      project.configuration.updates.each do |conf|
        create(
          :update_job,
          project: project,
          package_ecosystem: conf[:package_ecosystem],
          directory: conf[:directory],
          cron: conf[:cron]
        )

        project.reload
      end
    end

    factory :project_with_mr do
      transient do
        dependency { "git" }
        update_from { "#{dependency}-1.8.0" }
        update_to { "#{dependency}-1.10.2" }
        state { "opened" }
        commit_message { "" }
        branch { "branch" }
        auto_merge { false }
      end

      after(:create) do |project, evaluator|
        create(
          :merge_request,
          project: project,
          main_dependency: evaluator.dependency,
          update_from: evaluator.update_from,
          update_to: evaluator.update_to,
          state: evaluator.state,
          commit_message: evaluator.commit_message,
          branch: evaluator.branch,
          auto_merge: evaluator.auto_merge
        )
      end
    end
  end
end
