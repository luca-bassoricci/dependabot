# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    transient do
      config_yaml do
        <<~YAML
          version: 2
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
    webhook_id { 1 }
    web_url { "#{AppConfig.gitlab_url}/#{name}" }

    configuration { association :configuration, strategy: :build, project_name: name, config_yaml: config_yaml }

    factory :project_with_mr do
      transient do
        dependency { "git" }
        update_from { "#{dependency}-1.8.0" }
        update_to { "#{dependency}-1.10.2" }
      end

      after(:create) do |project, evaluator|
        create(
          :merge_request,
          project: project,
          main_dependency: evaluator.dependency,
          update_from: evaluator.update_from,
          update_to: evaluator.update_to
        )
      end
    end
  end
end
