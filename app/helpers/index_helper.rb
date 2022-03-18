# frozen_string_literal: true

module IndexHelper
  LANGUAGE_LABELS = {
    "nuget" => ".NET",
    "cargo" => "rust",
    "composer" => "php",
    "pub" => "dart",
    "mix" => "elixir",
    "gomod" => "go",
    "maven" => "java",
    "gradle" => "java",
    "bundler" => "ruby",
    "pip" => "python",
    "npm" => "javascript",
    "gitsubmodule" => "submodules"
  }.freeze

  # Fetch specific merge requests
  #
  # @param [Project] project
  # @param [String] package_ecosystem
  # @param [String] directory
  # @return [Mongoid::Criteria]
  def open_merge_requests(project, package_ecosystem, directory)
    project.merge_requests.where(package_ecosystem: package_ecosystem, directory: directory, state: "opened")
  end

  # :reek:LongParameterList

  # Open merge requests url
  #
  # @param [Porject] project
  # @param [String] package_ecosystem
  # @param [String] directory
  # @return [String]
  def open_mrs_url(project, package_ecosystem, directory)
    entry = project.configuration.entry(package_ecosystem: package_ecosystem, directory: directory)
    labels = entry[:custom_labels] || (["dependencies"] << LANGUAGE_LABELS.fetch(package_ecosystem, package_ecosystem))

    project_name = project.forked_from_name || project.name
    base_url = "#{AppConfig.gitlab_url}/#{project_name}/-/merge_requests"
    base_args = "scope=all&state=opened"
    label_args = "label_name[]=#{labels.join('&label_name[]=')}"

    "#{base_url}?#{base_args}&#{label_args}"
  end
end
