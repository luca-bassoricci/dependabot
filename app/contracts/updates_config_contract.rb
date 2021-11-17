# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
class UpdatesConfigContract < Dry::Validation::Contract
  params do
    config.validate_keys = true

    required(:updates).array(:hash) do
      required(:"package-ecosystem").filled(:string)
      required(:directory).filled(:string)

      if AppConfig.standalone?
        optional(:schedule).hash do
          optional(:interval).filled(:string)
          optional(:day).value(:string)
          optional(:time).value(:string)
          optional(:timezone).value(:string)
        end
      else
        required(:schedule).hash do
          required(:interval).filled(:string)
          optional(:day).value(:string)
          optional(:time).value(:string)
          optional(:timezone).value(:string)
        end
      end

      optional(:"commit-message").hash do
        optional(:prefix).filled(:string)
        optional(:"prefix-development").filled(:string)
        optional(:include).filled(:string)
      end

      optional(:allow).array(:hash) do
        optional(:"dependency-type").filled(:string)
        optional(:"dependency-name").filled(:string)
      end

      optional(:ignore).array(:hash) do
        required(:"dependency-name").filled(:string)
        optional(:versions).array(:str?)
        optional(:"update-types").array(:str?)
      end

      optional(:"pull-request-branch-name").hash do
        optional(:separator).filled(:string)
        optional(:prefix).filled(:string)
      end

      optional(:registries) { filled? > array? | eql?("*") }
      optional(:assignees).array(:str?)
      optional(:reviewers).array(:str?)
      optional(:approvers).array(:str?)
      optional(:labels).array(:str?)
      optional(:milestone).filled(:string)
      optional(:vendor).filled(:bool?)
      optional(:"open-pull-requests-limit").filled(:integer)
      optional(:"rebase-strategy").filled(:string)
      optional(:"target-branch").filled(:string)
      optional(:"auto-merge").filled(:bool?)
      optional(:"versioning-strategy").filled(:string)
      optional(:"insecure-external-code-execution").filled(:string)
    end
  end
end
# rubocop:enable Metrics/BlockLength
