# frozen_string_literal: true

module Gitlab
  module Vulnerabilities
    # Vulnerability alert issue template
    #
    class IssueTemplate < ApplicationService
      # Issue template
      #
      # @param [Vulnerability] vulnerability
      # @param [String] manifest_file
      def initialize(vulnerability, dependency_file)
        @description = vulnerability.description
        @package = vulnerability.package
        @permalink = vulnerability.permalink
        @patched_versions = vulnerability.first_patched_version
        @affected_versions = vulnerability.vulnerable_version_range
        @severity = vulnerability.severity
        @package_ecosystem = vulnerability.package_ecosystem
        @identifiers = vulnerability.identifiers
        @references = vulnerability.references
        @dependency_file = dependency_file
      end

      attr_reader :description,
                  :package,
                  :permalink,
                  :patched_versions,
                  :affected_versions,
                  :severity,
                  :package_ecosystem,
                  :identifiers,
                  :references,
                  :dependency_file

      delegate :directory, :path, to: :dependency_file

      def call
        heading_table = Terminal::Table.new(style: { border: :markdown }) do |table|
          table.headings = ["Package", "Severity", "Affected versions", "Patched versions", "IDs"]
          table << [
            "#{package} (#{Github::Vulnerabilities::Fetcher::PACKAGE_ECOSYSTEMS[package_ecosystem]})",
            severity,
            affected_versions,
            patched_versions,
            identifiers.map { |it| "`#{it}`" }.join(",")
          ]
        end

        <<~MARKDOWN
          ⚠️ `dependabot-gitlab` has detected security vulnerability for `#{package}` in path: `#{directory}`, manifest_file: `#{path}` but was unable to update it! ⚠️

          * #{permalink}

          #{heading_table}

          # Description

          #{description}

          # References

          * #{references.join("\n* ")}
        MARKDOWN
      end
    end
  end
end
