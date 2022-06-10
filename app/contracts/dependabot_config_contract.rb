# frozen_string_literal: true

class DependabotConfigContract < Dry::Validation::Contract
  params do
    required(:version).filled(:integer)
    required(:updates).filled(:array)

    optional(:registries).hash
    optional(:fork).filled(:bool?)

    optional(:"vulnerability-alerts").hash do
      required(:enabled).filled(:bool?)
      optional(:assignees).array(:str?)
    end
  end
end
