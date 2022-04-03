# frozen_string_literal: true

FactoryBot.define do
  factory :merge_request do
    id { Faker::Number.number(digits: 10) }
    iid { Faker::Number.number(digits: 10) }
    package_ecosystem { "bundler" }
    directory { "/" }
    state { "opened" }
    branch { "dependabot-bundler-#{main_dependency}-#{update_to}" }
    target_branch { "main" }
    commit_message { "" }
    auto_merge { false }
    update_from { nil }
    update_to { nil }
    main_dependency { nil }

    project
  end
end
