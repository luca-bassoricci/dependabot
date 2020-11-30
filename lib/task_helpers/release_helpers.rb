# frozen_string_literal: true

require "semver"

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

  # Commit list for ref range
  #
  # @return [Array]
  def commits
    @commits ||= gitlab
                 .commits(PROJECT_ID, ref_name: ref_range, first_parent: true, with_stats: true)
                 .auto_paginate
                 .select { |commit| commit.message.start_with?("Merge") }
                 .map { |commit| "- #{commit.message.split("\n\n").drop(1).join('. ')}" }
  end

  # Get changelog entry
  #
  # @return [String]
  def changelog
    changelist = commits.join("\n")
    breaking = changelist.include?("BREAKING")

    <<~CHANGELOG
      ## [#{ref_to}](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/#{ref_from}...#{ref_to})#{breaking ? ' *BREAKING*' : ''}

      #{changelist}
    CHANGELOG
  end
end

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
    gitlab.project_release(PROJECT_ID, ref_to)
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
      semver(ref_from).tap { |ver| ver.minor += 1 }
    end

    # Increase major version
    #
    # @param [String] ref_from
    # @return [SemVer]
    def major(ref_from)
      semver(ref_from).tap { |ver| ver.major += 1 }
    end
  end

  # Update changelog
  #
  # @return [void]
  def update_changelog
    logger.info { "Updating changelog" }
    notes = <<~NOTES.strip
      # CHANGELOG

      #{changelog}
      #{File.read('CHANGELOG.md').match(/^# CHANGELOG\n\n([ \n\S]+)/)[1]}
    NOTES

    File.write("CHANGELOG.md", notes, mode: "w")
  end

  # Commit update changelog and create tag
  #
  # @return [void]
  def commit_and_tag
    logger.info { "Comitting changelog" }
    exec(<<~CMD)
      git commit CHANGELOG.md -m "Update to #{ref_to}" && git tag #{ref_to}
    CMD
  end
end
