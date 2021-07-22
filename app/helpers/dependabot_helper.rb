# frozen_string_literal: true

module DependabotHelper
  # Unique project and package manager specific repo content path
  #
  # @param [String] project_name
  # @param [Hash] config
  # @return [String]
  def self.repo_contents_path(project_name, config)
    return unless config
    return unless config[:vendor] || Dependabot::Utils.always_clone_for_package_manager?(config[:package_manager])

    Rails.root.join("tmp", "repo-contents", project_name, Time.zone.now.strftime("%d-%m-%Y-%H-%M-%S"))
  end

  def errors(job)
    JobErrors.find_by(name: execution_context_name(job.args.first)).run_errors.join("\n")
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end
end
