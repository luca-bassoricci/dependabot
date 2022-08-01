# frozen_string_literal: true

# Gitlab project
#
# @!attribute id
#   @return [Integer]
# @!attribute name
#   @return [String]
# @!attribute forked_from_id
#   @return [Integer]
# @!attribute forked_from_name
#   @return [String]
# @!attribute webhook_id
#   @return [Integer]
# @!attribute web_url
#   @return [String]
# @!attribute gitlab_access_token
#   @return [String]
# @!attribute merge_requests
#   @return [Array<MergeRequest>]
# @!attribute vulnerability_issues
#   @return [Array<VulnerabilityIssue>]
# @!attribute update_jobs
#   @return [Array<UpdateJob>]
# @!attribute configuration
#   @return [Configuration]
class Project
  include Mongoid::Document

  unalias_attribute :id

  field :name, type: String
  field :id, type: Integer
  field :forked_from_id, type: Integer
  field :forked_from_name, type: String
  field :webhook_id, type: Integer
  field :web_url, type: String
  field :gitlab_access_token, type: EncryptedString

  has_many :merge_requests, dependent: :destroy
  has_many :vulnerability_issues, dependent: :destroy
  has_many :update_jobs, dependent: :destroy

  embeds_one :configuration

  # All open merge requests
  #
  # @param [String] package_ecosystem
  # @param [String] directory
  # @return [Array<MergeRequest>]
  def open_merge_requests(package_ecosystem:, directory:)
    merge_requests.where(
      package_ecosystem: package_ecosystem,
      directory: directory,
      state: "opened"
    )
  end

  # Project open merge requests
  #
  # @param [String] dependency_name
  # @param [String] directory
  # @return [Array<MergeRequest>]
  def open_dependency_merge_requests(dependency_name, directory)
    merge_requests
      .where(main_dependency: dependency_name, directory: directory, state: "opened")
      .compact
  end

  # Open superseded merge requests
  #
  # @param [String] directory
  # @param [String] update_from
  # @param [Integer] mr_iid
  # @return [Array<MergeRequest>]
  def superseded_mrs(directory:, update_from:, mr_iid:)
    merge_requests
      .where(update_from: update_from, directory: directory, state: "opened")
      .not(iid: mr_iid)
      .compact
  end

  # Open vulnerability issues
  #
  # @param [String] package_ecosystem
  # @param [String] directory
  # @param [String] package
  # @return [Array<VulnerabilityIssue>]
  def open_vulnerability_issues(package_ecosystem:, directory:, package:)
    vulnerability_issues
      .where(
        directory: directory,
        package: package,
        package_ecosystem: package_ecosystem,
        status: "opened"
      )
  end

  # Return projects hash representation
  #
  # @return [Hash]
  def to_hash
    {
      id: id,
      name: name,
      forked_from_id: forked_from_id,
      forked_from_name: forked_from_name,
      webhook_id: webhook_id,
      web_url: web_url,
      config: configuration&.updates
    }
  end
end
