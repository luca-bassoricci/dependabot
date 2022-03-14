# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
class UpdatesConfigContract < Dry::Validation::Contract
  params do
    required(:updates).array(:hash) do
      required(:"package-ecosystem").filled(:string)
      required(:directory).filled(:string)

      if AppConfig.standalone?
        optional(:schedule).hash do
          optional(:interval).value(:string)
          optional(:day).value(:string)
          optional(:time).value(:string)
          optional(:timezone).value(:string)
          optional(:hours).filled(:string)
        end
      else
        required(:schedule).hash do
          required(:interval).filled(:string)
          optional(:day).filled(:string)
          optional(:time).filled(:string)
          optional(:timezone).filled(:string)
          optional(:hours).filled(:string)
        end
      end

      optional(:"commit-message").hash do
        optional(:prefix).filled(:string)
        optional(:"prefix-development").filled(:string)
        optional(:include).filled(:string)
        optional(:trailers).array(:hash)
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

      optional(:"auto-merge") { filled? > bool? | hash? }
      optional(:"rebase-strategy") { filled? > str? | hash? }

      optional(:registries) { filled? > array? | eql?("*") }
      optional(:assignees).array(:str?)
      optional(:reviewers).array(:str?)
      optional(:approvers).array(:str?)
      optional(:labels).array(:str?)
      optional(:milestone).filled(:string)
      optional(:vendor).filled(:bool?)
      optional(:"open-pull-requests-limit").filled(:integer)
      optional(:"target-branch").filled(:string)
      optional(:"versioning-strategy").filled(:string)
      optional(:"insecure-external-code-execution").filled(:string)
    end
  end

  rule(:updates).each do |index:|
    hours = value.dig(:schedule, :hours)
    next unless hours

    pattern = "^\\d{1,2}-\\d{1,2}$"
    key_index = [:schedule, :hours, index]

    if !Regexp.new(pattern).match?(hours)
      key(key_index).failure("has invalid format, must match pattern '#{pattern}'")
    elsif hours.split("-").yield_self { |num| num[0].to_i >= num[1].to_i }
      key(key_index).failure("has invalid format, first number in range must be smaller or equal than second")
    elsif hours.split("-").any? { |num| num.to_i <= 0 && num.to_i >= 23 }
      key(key_index).failure("has invalid format, hours must be between 0 and 23")
    end
  end
end
# rubocop:enable Metrics/BlockLength
