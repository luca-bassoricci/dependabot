# frozen_string_literal: true

module DependabotHelper
  # Unique project and package manager specific repo content path
  #
  # @param [String] project_name
  # @param [Hash] config
  # @return [String]
  def self.repo_contents_path(project_name, config)
    return unless config[:vendor] || Dependabot::Utils.always_clone_for_package_manager?(config[:package_manager])

    directory = config[:directory] == "/" ? "" : config[:directory]
    Rails.root.join("tmp", "repo-contents", project_name, directory, config[:package_manager])
  end
end
