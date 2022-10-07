# frozen_string_literal: true

require_relative "util"

class ChangelogHelper
  def initialize(version, changelog_file)
    @version = SemVer.parse(version).format(Util::VERSION_PATTERN)
    @changelog_file = changelog_file
    @project_name = "dependabot-gitlab/dependabot"
  end

  # Update changelog
  #
  # @return [void]
  def update_changelog
    logger.info("Fetching changelog for version '#{version}'")
    File.write(changelog_file, changelog, mode: "w")

    logger.info("Updating CHANGELOG.md")
    gitlab.generate_changelog(project_name, version, trailer: "changelog")
  end

  # :reek:NestedIterators
  # :reek:TooManyStatements

  # Update closed issues with release number
  #
  # @return [void]
  def update_issues # rubocop:disable Metrics/CyclomaticComplexity
    logger.info("Adding release references to closed issues")
    return logger.info(" no mrs found in release") if mr_list.empty?

    mr_list.each do |mr|
      logger.info(" updating closed issues for mr !#{mr[:iid]}")
      next logger.info("  mr has no closed issues") if mr[:closed_issues].empty?

      word = mr[:fix] ? "fixed" : "implemented"
      mr[:closed_issues].each do |iid|
        logger.info("  updating issue ##{iid}")
        note = ":tada: This issue has been #{word} in release [v#{version}](release_url) :tada:"
        next if gitlab.issue_notes(project_name, iid).any? { |note| note.body == note }

        gitlab.create_issue_note(project_name, iid, note)
      end
    end
  end

  private

  include Util

  attr_reader :version, :project_name, :changelog_file

  # Release url
  #
  # @return [String]
  def release_url
    @release_url ||= "https://gitlab.com/#{project_name}/-/releases/v#{version}"
  end

  # Release changelog
  #
  # @return [String]
  def changelog
    @changelog ||= gitlab.get_changelog(project_name, version, trailer: "changelog").notes
  end

  # MR list with closed issues
  #
  # @return [Array<Hash>]
  def mr_list
    @mr_list ||= changelog.scan(/#{project_name}!(\d+)/).flatten.map do |iid|
      {
        iid: iid,
        fix: gitlab.merge_request(project_name, iid).source_branch.start_with?("fix"),
        closed_issues: gitlab.merge_request_closes_issues(project_name, iid.to_i).map(&:iid)
      }
    end
  end
end
