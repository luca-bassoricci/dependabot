# frozen_string_literal: true

class AutoMergeConfigContract < Dry::Validation::Contract
  params do
    optional(:"auto-merge").hash do
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
