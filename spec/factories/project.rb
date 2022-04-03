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
  end
end
