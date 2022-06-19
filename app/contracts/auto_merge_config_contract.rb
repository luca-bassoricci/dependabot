# frozen_string_literal: true

class AutoMergeConfigContract < Dry::Validation::Contract
  params do
    config.validate_keys = true

    required(:"auto-merge").hash do
      optional(:squash).filled(:bool?)
      optional(:allow).array(:hash) do
        required(:"dependency-name").filled(:string)
        optional(:versions).array(:str?)
        optional(:"update-types").array(:str?)
      end
      optional(:ignore).array(:hash) do
        required(:"dependency-name").filled(:string)
        optional(:versions).array(:str?)
        optional(:"update-types").array(:str?)
      end
    end
  end
end
