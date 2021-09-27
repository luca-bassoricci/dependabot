# frozen_string_literal: true

class ChartReleaseHelper
  VER_PATTERN = "%M.%m.%p"
  CHART = "charts/dependabot-gitlab/Chart.yaml"
  README = "charts/dependabot-gitlab/README.md"

  def initialize(version)
    @app_version = SemVer.parse(version)
    @path = "/tmp/checkout"
    @repo_name = "charts"
  end

  def self.call(version)
    new(version).update
  end

  def update
    clone_repo

    Dir.chdir(repo_path) do
      update_chart
      update_readme
    end

    commit_changes
  end

  private

  attr_reader :app_version, :path, :repo_name, :git

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

  def clone_repo
    logger.info("Clone charts repository to #{path}")
    @git = Git.clone("git@github.com:andrcuns/charts.git", repo_name, path: path)
  end

  def repo_path
    @repo_path ||= "#{path}/#{repo_name}"
  end

  def chart
    @chart ||= YAML.load_file(CHART)
  end

  def updated_chart
    @updated_chart ||= chart.clone
  end

  def commit_changes
    logger.info("Commit changes")
    git.add([CHART, README])
    git.commit("dependabot-gitlab: Update chart version to #{updated_chart['version']}")
    git.push
  end

  def update_chart
    logger.info("Update chart version")
    update_app_version
    update_chart_version

    File.write(CHART, updated_chart.to_yaml)
  end

  def update_app_version
    updated_chart["appVersion"] = app_version.format(VER_PATTERN)
  end

  def update_chart_version
    updated_chart["version"] = SemVer
                               .parse(chart["version"])
                               .tap { |ver| ver.patch += 1 }
                               .format(VER_PATTERN)
  end

  def update_readme
    u_readme = File.read(README)
                   .gsub(chart["version"], updated_chart["version"])
                   .gsub(chart["appVersion"], updated_chart["appVersion"])

    File.write(README, u_readme)
  end
end
