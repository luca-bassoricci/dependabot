# frozen_string_literal: true

class UpdateChecker < ApplicationService
  attr_reader :checker

  def call(dependency:, dependency_files:, package_manager: "bundler")
    @checker = Dependabot::UpdateCheckers.for_package_manager(package_manager).new(
      dependency: dependency,
      dependency_files: dependency_files,
      credentials: Credentials.call
    )
    self
  end

  def requirements_to_unlock
    unless checker.requirements_unlocked_or_can_be?
      return checker.can_update?(requirements_to_unlock: :none) ? :none : :update_not_possible
    end
    return :own if checker.can_update?(requirements_to_unlock: :own)
    return :all if checker.can_update?(requirements_to_unlock: :all)

    :update_not_possible
  end
end
