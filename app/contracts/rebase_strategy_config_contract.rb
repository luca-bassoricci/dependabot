# frozen_string_literal: true

class RebaseStrategyConfigContract < Dry::Validation::Contract
  params do
    config.validate_keys = true

    required(:"rebase-strategy").hash do
      optional(:strategy).filled(:string)
      optional(:"on-approval").filled(:bool?)
      optional(:"with-assignee").filled(:string)
    end
  end
end
