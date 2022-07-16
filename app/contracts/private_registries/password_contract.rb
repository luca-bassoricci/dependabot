# frozen_string_literal: true

module PrivateRegistries
  class PasswordContract < Dry::Validation::Contract
    params do
      config.validate_keys = true

      required(:type).filled(:string)
      required(:url).filled(:string)
      required(:username).filled(:string)
      required(:password).filled(:string)
      optional(:"replaces-base").filled(:bool?) # used in python-index
    end
  end
end
