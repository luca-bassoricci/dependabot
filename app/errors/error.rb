# frozen_string_literal: true

module Error
  module Dependabot
    class MissingConfiguration < StandardError; end

    class InvalidConfiguration < StandardError
      def self.format(result)
        result.errors.group_by(&:path).map do |path, messages|
          "#{path.drop(1).join('.')}: #{messages.map(&:text).join('; ')}"
        end.join("\n")
      end
    end
  end
end
