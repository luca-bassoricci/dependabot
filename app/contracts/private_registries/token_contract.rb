# frozen_string_literal: true

module PrivateRegistries
  class TokenContract < Dry::Validation::Contract
    params do
      config.validate_keys = true

      required(:type).filled(:string)
      required(:url).filled(:string)
      required(:token).filled(:string)
      optional(:"replaces-base").filled(:bool?) # used in python-index
    end
  end
end
