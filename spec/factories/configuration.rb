# frozen_string_literal: true

FactoryBot.define do
  factory :configuration do
    transient do
      parsed_config { Dependabot::Config::Parser.call(config_yaml, project_name) }
      project_name { Faker::Alphanumeric.unique.alpha(number: 15) }
      config_yaml { "" }
    end

    updates { parsed_config[:updates] }
    registries { parsed_config[:registries] }
  end
end
