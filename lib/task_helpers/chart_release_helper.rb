# frozen_string_literal: true

require_relative "util"

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
      "main",
      "Update app version to #{app_version}\n\nchangelog: dependency",
      commit_actions
    )
  end

  private

  include Util

  attr_reader :app_version, :chart_repo

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
    @chart ||= gitlab.file_contents(chart_repo, CHART, "main")
  end

  # Readme file
  #
  # @return [String]
  def readme
    @readme ||= gitlab.file_contents(chart_repo, README, "main")
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
