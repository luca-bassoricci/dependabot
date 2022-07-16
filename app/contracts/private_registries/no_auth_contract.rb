# frozen_string_literal: true

module PrivateRegistries
  class NoAuthContract < Dry::Validation::Contract
    params do
      config.validate_keys = true

      required(:type).filled(:string)
      required(:url).filled(:string)
    end
  end
end
