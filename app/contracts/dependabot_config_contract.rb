# frozen_string_literal: true

class DependabotConfigContract < Dry::Validation::Contract
  params do
    required(:version).filled(:integer)
    required(:updates).filled(:array)

    optional(:registries).hash
  end
end
