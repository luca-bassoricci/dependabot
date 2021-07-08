# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
class DependabotConfigContract < Dry::Validation::Contract
  params do
    required(:version).filled(:integer)

    required(:updates).array(:hash) do
      required(:"package-ecosystem").filled(:string)
      required(:directory).filled(:string)

      unless AppConfig.standalone?
        required(:schedule).hash do
          required(:interval).filled(:string)

          optional(:time).value(:string)
          optional(:timezone).value(:string)
        end
      end

      optional(:"commit-message").hash do
        optional(:prefix).filled(:string)
        optional(:"prefix-development").filled(:string)
        optional(:scope).filled(:string)
      end

      optional(:allow).array(:hash) do
        optional(:"dependency-type").filled(:string)
        optional(:"dependency-name").filled(:string)
      end
      optional(:ignore).array(:hash) do
        required(:"dependency-name").filled(:string)
        optional(:versions).array(:str?)
      end
      optional(:"pull-request-branch-name").hash do
        required(:separator).filled(:string)
      end

      optional(:assignees).filled(:array)
      optional(:reviewers).filled(:array)
      optional(:lables).array(:str?)
      optional(:milestone).value(:string)
      optional(:"open-pull-requests-limit").filled(:integer)
      optional(:"rebase-strategy").filled(:string)
      optional(:"target-branch").filled(:string)
      optional(:vendor).filled(:bool?)
    end
  end
end
# rubocop:enable Metrics/BlockLength
