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
    auto_merge { false }
    squash { false }
    update_to { "test-0.2.0" }
    update_from { "test-0.1.0" }
    commit_message { "commit-message" }
    target_project_id { nil }

    project
  end
end
