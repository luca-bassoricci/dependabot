# frozen_string_literal: true

module IndexHelper
  # Fetch specific merge requests
  #
  # @param [Project] project
  # @param [String] package_ecosystem
  # @param [String] directory
  # @return [Mongoid::Criteria]
  def open_merge_requests(project, package_ecosystem, directory)
    project.merge_requests.where(package_ecosystem: package_ecosystem, directory: directory, state: "opened")
  end

  # Open merge requests url
  #
  # @param [Porject] project
  # @param [String] package_ecosystem
  # @param [String] directory
  # @return [String]
  def open_mrs_url(project, package_ecosystem, directory)
    entry = project.config.entry(package_ecosystem: package_ecosystem, directory: directory)
    labels = entry[:custom_labels] || ["dependencies"]

    project_name = project.forked_from_name || project.name
    base_url = "#{AppConfig.gitlab_url}/#{project_name}/-/merge_requests"
    base_args = "scope=all&state=opened"
    label_args = "label_name[]=#{labels.join('&label_name[]=')}"

    "#{base_url}?#{base_args}&#{label_args}"
  end
end
