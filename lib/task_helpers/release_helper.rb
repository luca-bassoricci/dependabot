# frozen_string_literal: true

require_relative "util"

# Create release tag and update VERSION file
#
class ReleaseHelper
  private_instance_methods :new

  def initialize(version)
    @version_file_name = "app/services/version.rb"
    @version_file = File.read(@version_file_name)
    @version = version
  end

  # Update changelog and create new tag
  #
  # @param [String] version
  # @return [void]
  def self.call(version)
    new(version).call
  end

  # Update changelog and create new tag
  #
  # @param [String] version
  # @return [void]
  def call
    update_version
    commit_and_tag
    print_changelog
  end

  # Update changelog
  #
  # @return [void]
  def update_version
    logger.info("Updating version to #{ref_to}")
    logger.info("Updating VERSION file")

    updated_v = version_file.gsub(/\d+\.\d+\.\d+/, ref_to.to_s.delete("v"))
    File.write(version_file_name, updated_v, mode: "w")
  end

  # Commit update changelog and create tag
  #
  # @return [void]
  def commit_and_tag
    logger.info("Comitting VERSION file")

    git = Git.init
    git.add(version_file_name)
    git.commit("Update app version to #{ref_to}", no_verify: true)

    logger.info("Creating release tag")
    git.add_tag(ref_to.to_s)
  end

  # Log changes in new release
  #
  # @return [void]
  def print_changelog
    changelog = gitlab.get_changelog("dependabot-gitlab/dependabot", ref_to, trailer: "changelog", from: ref_from).notes
    logger.info("Release contains following changes:\n#{changelog}")
  end

  private

  include Util

  attr_reader :version_file_name, :version_file, :version

  # Current version
  #
  # @return [String]
  def ref_from
    @ref_from ||= "v#{version_file.match(/VERSION = "(\d+\.\d+\.\d+)"/)[1]}"
  end

  # New version
  #
  # @return [SemVer]
  def ref_to
    send(version, ref_from)
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

  # Semver of ref from
  #
  # @param [String] ref_from
  # @return [SemVer]
  def semver(ref_from)
    SemVer.parse(ref_from)
  end
end
