# frozen_string_literal: true

require "semver"
require "git"

# Release helper which generate proper release notes
# It requires linear repo history with only merges in to main brunch.
# All commits must be prefixed with one of the category prefixes configured in .gitlab/changelog_config.yml
#
class ReleaseHelper
  include ApplicationHelper

  PROJECT_ID = 17_993_652

  private_instance_methods :new

  def initialize(ref_from, ref_to, ref_range)
    @ref_from = ref_from
    @ref_to = ref_to
    @ref_range = ref_range
  end

  # Project release tags
  #
  # @return [Array]
  def self.release_tags
    ApplicationHelper.gitlab.tags(PROJECT_ID, search: "^v").map(&:name)
  end

  delegate :logger, to: Rails

  attr_reader :ref_from, :ref_to, :ref_range

  # Release categories config
  #
  # @return [Hash]
  def config
    @config ||= YAML.load_file(".gitlab/changelog_config.yml")["categories"]
  end

  # Commit list for ref range
  #
  # @return [Array]
  def commits
    @commits ||= gitlab
                 .commits(PROJECT_ID, ref_name: ref_range, first_parent: true, with_stats: true)
                 .auto_paginate
                 .select { |commit| commit.message.start_with?("Merge") }
  end

  # Changes split by categories
  #
  # @return [Hash]
  def categorized_changes
    @categorized_changes ||= commits.each_with_object(config.transform_values { |_| [] }) do |commit, hash|
      committer = commit.committer_name
      message = commit.message.split("\n\n").drop(1).join(". ")

      next unless message.match?(/^(#{config.keys.join("|")}):/)

      category = message.match(/(\S+): \S+/)[1]

      hash[category].push("- " + message.gsub("#{category}: ", "") + " - (#{committer})") # rubocop:disable Style/StringConcatenation
    end
  end

  # Get changelog entry
  #
  # @return [String]
  def changelog
    raise("No changes to generate changelog from detected!") if categorized_changes.all?(&:empty?)

    changelist = categorized_changes
                 .reject { |_category, messages| messages.empty? }
                 .map { |category, messages| "### #{config[category]}\n\n#{messages.join("\n")}\n" }
                 .join("\n")

    <<~CHANGELOG
      #{changelist}
      ### 👀 Links

      [Commits since #{ref_from}](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/#{ref_from}...#{ref_to})
    CHANGELOG
  end
end

# Create a github release for already pushed tag
#
class GitlabReleaseCreator < ReleaseHelper
  private_instance_methods :new

  def initialize(version)
    ref_to = version
    ref_from = ReleaseHelper.release_tags[1]

    super(ref_from, ref_to, "#{ref_from}..#{ref_to}")
  end

  # Create new gitlab release
  #
  # @param [String] version
  # @return [void]
  def self.call(version)
    creator = new(version)
    raise("Release #{version} already exists!") if creator.release?

    creator.create_release
  end

  # Check if release already exists
  #
  # @return [Gitlab::ObjectifiedHash]
  def release?
    # Gitlab returns 403 for specific find release endpoint
    gitlab.project_releases(PROJECT_ID).auto_paginate.detect { |release| release.tag_name == ref_to }
  end

  # Create gitlab release
  #
  # @return [Gitlab::ObjectifiedHash]
  def create_release
    gitlab.create_project_release(PROJECT_ID, tag_name: ref_to, name: ref_to, description: changelog)
  end
end

# Create release by incrementing latest tag and updating changelog
#
class ReleaseCreator < ReleaseHelper
  private_instance_methods :new

  def initialize(version)
    ref_from = ReleaseHelper.release_tags.first
    ref_to = self.class.send(version, ref_from)

    super(ref_from, ref_to, "#{ref_from}..HEAD")
  end

  class << self
    # Update changelog and create new tag
    #
    # @param [String] version
    # @return [void]
    def call(version)
      creator = new(version)
      creator.update_changelog
      creator.commit_and_tag
    end

    private

    # Semver of ref from
    #
    # @param [String] ref_from
    # @return [SemVer]
    def semver(ref_from)
      SemVer.parse(ref_from)
    end

    # Increase patch version
    #
    # @param [String] ref_from
    # @return [SemVer]
    def patch(ref_from)
      semver(ref_from).tap { |ver| ver.patch += 1 }
    end

    # Increase minor version
    #
    # @param [String] ref_from
    # @return [SemVer]
    def minor(ref_from)
      semver(ref_from).tap do |ver|
        ver.minor += 1
        ver.patch = 0
      end
    end

    # Increase major version
    #
    # @param [String] ref_from
    # @return [SemVer]
    def major(ref_from)
      semver(ref_from).tap do |ver|
        ver.major += 1
        ver.minor = 0
        ver.patch = 0
      end
    end
  end

  # Update changelog
  #
  # @return [void]
  def update_changelog
    log(:info, "Updating changelog")

    cl = changelog
    breaking = cl.include?("[BREAKING]")

    notes = <<~NOTES.strip
      # CHANGELOG

      ## [#{ref_to} - #{Time.current.to_date}](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)#{breaking ? ' *BREAKING*' : ''}

      #{cl}
      #{File.read('CHANGELOG.md').match(/^# CHANGELOG\n\n([ \n\S]+)/)[1]}
    NOTES

    File.write("CHANGELOG.md", "#{notes}\n", mode: "w")
  end

  # Commit update changelog and create tag
  #
  # @return [void]
  def commit_and_tag
    log(:info, "Comitting changelog")
    git = Git.init
    git.add("CHANGELOG.md")
    git.commit("Update to #{ref_to}", no_verify: true)
    git.add_tag(ref_to.to_s)
  end
end
