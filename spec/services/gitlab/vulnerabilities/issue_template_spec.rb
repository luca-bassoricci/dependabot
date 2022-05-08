# frozen_string_literal: true

describe Gitlab::Vulnerabilities::IssueTemplate, epic: :services, feature: :gitlab do
  subject(:actual_template) do
    described_class.call(vulnerability, instance_double(Dependabot::DependencyFile, path: "Gemfile", directory: "/"))
  end

  include_context "with dependabot helper"

  let(:vulnerability) { build(:vulnerability) }

  let(:expected_template) do
    <<~MARKDOWN
      ⚠️ `dependabot-gitlab` has detected security vulnerability for `nokogiri` in path: `/`, manifest_file: `Gemfile` but was unable to update it! ⚠️

      * https://github.com/advisories/GHSA-v6gp-9mmm-c6p5

      | Package             | Severity | Affected versions | Patched versions | IDs                   |
      |---------------------|----------|-------------------|------------------|-----------------------|
      | nokogiri (RUBYGEMS) | HIGH     | < 1.13.4          | 1.13.4           | `GHSA-v6gp-9mmm-c6p5` |

      # Description

      ## Summary

      Nokogiri v1.13.4 updates the vendored zlib from 1.2.11 to 1.2.12, which addresses [CVE-2018-25032](https://nvd.nist.gov/vuln/detail/CVE-2018-25032). That CVE is scored as CVSS 7.4 "High" on the NVD record as of 2022-04-05.

      ## Mitigation

      Upgrade to Nokogiri `>= v1.13.4`.

      ## Impact

      ### [CVE-2018-25032](https://nvd.nist.gov/vuln/detail/CVE-2018-25032) in zlib

      - **Severity**: High
      - **Type**: [CWE-787](https://cwe.mitre.org/data/definitions/787.html) Out of bounds write
      - **Description**: zlib before 1.2.12 allows memory corruption when deflating (i.e., when compressing) if the input has many distant matches.



      # References

      * https://github.com/sparklemotion/nokogiri/security/advisories/GHSA-v6gp-9mmm-c6p5
      * https://nvd.nist.gov/vuln/detail/CVE-2018-25032
      * https://github.com/advisories/GHSA-jc36-42cf-vqwj
      * https://github.com/sparklemotion/nokogiri/releases/tag/v1.13.4
      * https://groups.google.com/g/ruby-security-ann/c/vX7qSjsvWis/m/TJWN4oOKBwAJ?utm_medium=email&utm_source=footer
      * https://github.com/advisories/GHSA-v6gp-9mmm-c6p5
    MARKDOWN
  end

  it "renders vulnerability issue template" do
    expect(actual_template).to eq(expected_template)
  end
end
