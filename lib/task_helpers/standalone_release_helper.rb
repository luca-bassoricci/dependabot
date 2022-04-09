# frozen_string_literal: true

class StandaloneReleaseHelper
  IMAGE = "docker.io/andrcuns/dependabot-gitlab"
  CI_FILE = ".gitlab-ci.yml"
  PROJECT = "dependabot-gitlab/dependabot-standalone"
  VERSION_PATTERN = "%M.%m.%p"

  def initialize(version)
    @version = SemVer.parse(version).format(VERSION_PATTERN)
  end

  def self.call(version)
    new(version).update
  end

  def update
    logger.info("Updating dependabot-standalone image version")

    gitlab.edit_file(
      PROJECT,
      CI_FILE,
      "master",
      updated_gitlab_ci,
      "Update dependabot-gitlab version to #{version}\n\nchangelog: dependency"
    )
    gitlab.create_tag(PROJECT, version, "master")
  end

  private

  attr_reader :version

  # Gitlab client
  #
  # @return [Gitlab::Client]
  def gitlab
    @gitlab ||= Gitlab.client(
      endpoint: "https://gitlab.com/api/v4",
      private_token: ENV["GITLAB_ACCESS_TOKEN"]
    )
  end

  # Logger instance
  #
  # @return [Logger]
  def logger
    @logger ||= Logger.new($stdout)
  end

  # gitlab-ci.yml file contents
  #
  # @return [String]
  def gitlab_ci
    @gitlab_ci ||= gitlab.file_contents(PROJECT, CI_FILE)
  end

  # Version currently defined
  #
  # @return [String]
  def current_version
    @current_version ||= gitlab_ci.match(/DEPENDABOT_IMAGE: #{IMAGE}:(?<tag>[0-9.]+)/)[:tag]
  end

  # Updated .gitlab-ci.yml file
  #
  # @return [String]
  def updated_gitlab_ci
    @updated_gitlab_ci ||= gitlab_ci.gsub(current_version, version)
  end
end
