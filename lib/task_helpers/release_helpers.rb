# frozen_string_literal: true

require_relative "util"

# Create release tag and update VERSION file
#
class ReleaseCreator
  private_instance_methods :new

  def initialize(version)
    @ref_from = File.read("VERSION").strip
    @version = version
  end

  # Update changelog and create new tag
  #
  # @param [String] version
  # @return [void]
  def self.call(version)
    creator = new(version)
    creator.update_version
    creator.commit_and_tag
  end

  # Update changelog
  #
  # @return [void]
  def update_version
    logger.info("Updating VERSION")

    File.write("VERSION", ref_to, mode: "w")
  end

  # Commit update changelog and create tag
  #
  # @return [void]
  def commit_and_tag
    logger.info("Comitting VERSION")

    git = Git.init
    git.add("VERSION")
    git.commit("Update app version to #{ref_to}", no_verify: true)
    git.add_tag(ref_to.to_s)
  end

  private

  include Util

  attr_reader :ref_from, :version

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
