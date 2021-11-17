# frozen_string_literal: true

class ChartReleaseHelper
  VER_PATTERN = "%M.%m.%p"
  CHART = "charts/dependabot-gitlab/Chart.yaml"
  README = "README.md"

  def initialize(version)
    @app_version = SemVer.parse(version)
    @chart_repo = "dependabot-gitlab/chart"
  end

  def self.call(version)
    new(version).update
  end

  # Update app version in helm chart
  #
  # @return [void]
  def update
    logger.info("Updating app version to #{app_version}")
    gitlab.create_commit(
      chart_repo,
      "master",
      "Update app version to #{app_version}\n\nChangelog: feature",
      commit_actions
    )
  end

  private

  attr_reader :app_version, :chart_repo

  # Gitlab client
  #
  # @return [Gitlab::Client]
  def gitlab
    @gitlab ||= Gitlab.client(
      endpoint: "https://gitlab.com/api/v4",
      private_token: ENV["SETTINGS__GITLAB_ACCESS_TOKEN"]
    )
  end

  # Logger instance
  #
  # @return [Logger]
  def logger
    @logger ||= Logger.new($stdout)
  end

  # Updated Chart.yaml
  #
  # @return [String]
  def updated_chart
    chart.gsub(previous_version, new_version)
  end

  # Updated README.md
  #
  # @return [String]
  def updated_readme
    readme.gsub(previous_version, new_version)
  end

  # Chart yaml
  #
  # @return [String]
  def chart
    @chart ||= gitlab.file_contents(chart_repo, CHART)
  end

  # Readme file
  #
  # @return [String]
  def readme
    @readme ||= gitlab.file_contents(chart_repo, README)
  end

  # Previous app version
  #
  # @return [Integer]
  def previous_version
    @previous_version = YAML.safe_load(chart)["appVersion"]
  end

  # New version
  #
  # @return [Integer]
  def new_version
    @new_version ||= app_version.format(VER_PATTERN)
  end

  # Gitlab commit actions
  #
  # @return [Array]
  def commit_actions
    [
      {
        action: "update",
        file_path: CHART,
        content: updated_chart
      },
      {
        action: "update",
        file_path: README,
        content: updated_readme
      }
    ]
  end
end
