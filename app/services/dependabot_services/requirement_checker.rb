# frozen_string_literal: true

module DependabotServices
  class RequirementChecker < ApplicationService
    # Check update requirements
    # @param [Dependabot::UpdateChecker] checker
    # @return [Symbol]
    def call(checker)
      unless checker.requirements_unlocked_or_can_be?
        return checker.can_update?(requirements_to_unlock: :none) ? :none : :update_not_possible
      end
      return :own if checker.can_update?(requirements_to_unlock: :own)
      return :all if checker.can_update?(requirements_to_unlock: :all)

      :update_not_possible
    end
  end
end
