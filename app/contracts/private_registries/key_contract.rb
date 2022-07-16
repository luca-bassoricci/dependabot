# frozen_string_literal: true

module PrivateRegistries
  class KeyContract < Dry::Validation::Contract
    params do
      config.validate_keys = true

      required(:type).filled(:string)
      required(:organization).filled(:string)
      required(:key).filled(:string)
    end
  end
end
