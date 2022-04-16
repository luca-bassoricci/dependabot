# frozen_string_literal: true

module Support
  module Mocks
    module Gitlab # rubocop:disable Metrics/ModuleLength
      def project_mock
        <<~YML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "id": #{Faker::Number.number(digits: 10)},
                  "description": "Project for system tests",
                  "default_branch": "main",
                  "web_url": "#{AppConfig.gitlab_url}/#{project_name}"
                }
        YML
      end

      def hook_mock
        <<~YML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/hooks
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                []
        YML
      end

      def set_hook_mock
        <<~YML
          - request:
              method: POST
              path: /api/v4/projects/#{project_name}/hooks
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "id": 1
                }
        YML
      end

      def present_config_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/repository/files/.gitlab%2Fdependabot.yml
            response:
              status: 200
              headers:
                Content-Type: text/plain
              body: |
                {
                  "file_name": "dependabot.yml",
                  "file_path": ".gitlab/dependabot.yml"
                }
        YAML
      end

      def missing_config_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/repository/files/.gitlab%2Fdependabot.yml
            response:
              status: 404
              headers:
                Content-Type: text/plain
              body: ""
        YAML
      end

      def raw_config_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/repository/files/.gitlab%2Fdependabot.yml/raw
            response:
              status: 200
              headers:
                Content-Type: text/plain
              body: |
                version: 2
                updates:
                  - package-ecosystem: bundler
                    directory: "/"
                    schedule:
                      interval: daily
        YAML
      end

      def branch_head_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/repository/branches/main
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "name": "main",
                  "commit": {
                    "id": "d522b9716589980822850be63025b767f0d78768",
                    "short_id": "d522b971"
                  }
                }
        YAML
      end

      def file_tree_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/repository/tree
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                [
                  {
                    "id": "0fa78ba25aee3ed6f754c01441b7eb3d8897c3f7",
                    "name": "Gemfile",
                    "type": "blob",
                    "path": "Gemfile",
                    "mode": "100644"
                  },
                  {
                    "id": "c385e8593f517c93a25360a064a11fd8bb8f9353",
                    "name": "Gemfile.lock",
                    "type": "blob",
                    "path": "Gemfile.lock",
                    "mode": "100644"
                  }
                ]
        YAML
      end

      def dep_file_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/repository/files/Gemfile
              query_params:
                ref: d522b9716589980822850be63025b767f0d78768
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "file_name": "Gemfile",
                  "file_path": "Gemfile",
                  "size": 133,
                  "encoding": "base64",
                  "content_sha256": "5c7ebbeff2fe8fd21c8af05f2c137c7b33d5c5ebc35cd152c0ccf771ba7b53eb",
                  "ref": "d522b9716589980822850be63025b767f0d78768",
                  "blob_id": "0fa78ba25aee3ed6f754c01441b7eb3d8897c3f7",
                  "commit_id": "d522b9716589980822850be63025b767f0d78768",
                  "last_commit_id": "a561e142fb670429c9661ecafc581acc6a5d16d2",
                  "content": "IyBmcm96ZW5fc3RyaW5nX2xpdGVyYWw6IHRydWUKCnNvdXJjZSAiaHR0cHM6Ly9ydWJ5Z2Vtcy5vcmciCgpnZW0gImZha2VyIiwgIn4+IDEuOSIKZ2VtICJnaXQiLCAifj4gMS44LjAiCmdlbSAicnVib2NvcCIsICJ+PiAxLjE5LjEiCg=="
                }
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/repository/files/Gemfile.lock
              query_params:
                ref: d522b9716589980822850be63025b767f0d78768
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "file_name": "Gemfile.lock",
                  "file_path": "Gemfile.lock",
                  "size": 870,
                  "encoding": "base64",
                  "content_sha256": "253572af01fdebfe6a9ecda792f1070cfb6ea8f3a8d9d1d860c5d685837c574d",
                  "ref": "d522b9716589980822850be63025b767f0d78768",
                  "blob_id": "c385e8593f517c93a25360a064a11fd8bb8f9353",
                  "commit_id": "d522b9716589980822850be63025b767f0d78768",
                  "last_commit_id": "a561e142fb670429c9661ecafc581acc6a5d16d2",
                  "content": "R0VNCiAgcmVtb3RlOiBodHRwczovL3J1YnlnZW1zLm9yZy8KICBzcGVjczoKICAgIGFzdCAoMi40LjIpCiAgICBjb25jdXJyZW50LXJ1YnkgKDEuMS45KQogICAgZmFrZXIgKDEuOS42KQogICAgICBpMThuICg+PSAwLjcpCiAgICBnaXQgKDEuOC4wKQogICAgICByY2hhcmRldCAofj4gMS44KQogICAgaTE4biAoMS44LjExKQogICAgICBjb25jdXJyZW50LXJ1YnkgKH4+IDEuMCkKICAgIHBhcmFsbGVsICgxLjIxLjApCiAgICBwYXJzZXIgKDMuMC4zLjIpCiAgICAgIGFzdCAofj4gMi40LjEpCiAgICByYWluYm93ICgzLjAuMCkKICAgIHJjaGFyZGV0ICgxLjguMCkKICAgIHJlZ2V4cF9wYXJzZXIgKDIuMi4wKQogICAgcmV4bWwgKDMuMi41KQogICAgcnVib2NvcCAoMS4xOS4xKQogICAgICBwYXJhbGxlbCAofj4gMS4xMCkKICAgICAgcGFyc2VyICg+PSAzLjAuMC4wKQogICAgICByYWluYm93ICg+PSAyLjIuMiwgPCA0LjApCiAgICAgIHJlZ2V4cF9wYXJzZXIgKD49IDEuOCwgPCAzLjApCiAgICAgIHJleG1sCiAgICAgIHJ1Ym9jb3AtYXN0ICg+PSAxLjkuMSwgPCAyLjApCiAgICAgIHJ1YnktcHJvZ3Jlc3NiYXIgKH4+IDEuNykKICAgICAgdW5pY29kZS1kaXNwbGF5X3dpZHRoICg+PSAxLjQuMCwgPCAzLjApCiAgICBydWJvY29wLWFzdCAoMS4xNS4wKQogICAgICBwYXJzZXIgKD49IDMuMC4xLjEpCiAgICBydWJ5LXByb2dyZXNzYmFyICgxLjExLjApCiAgICB1bmljb2RlLWRpc3BsYXlfd2lkdGggKDIuMS4wKQoKUExBVEZPUk1TCiAgeDg2XzY0LWRhcndpbi0yMAoKREVQRU5ERU5DSUVTCiAgZmFrZXIgKH4+IDEuOSkKICBnaXQgKH4+IDEuOC4wKQogIHJ1Ym9jb3AgKH4+IDEuMTkuMSkKCkJVTkRMRUQgV0lUSAogICAyLjIuMzEK"
                }
        YAML
      end

      def users_mock
        <<~YAML
          - request:
              path: /api/v4/users
              method: GET
              query_params:
                search: andrcuns
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                [
                  {
                    "id": 1,
                    "username": "andrcuns"
                  }
                ]
          - request:
              path: /api/v4/users
              method: GET
              query_params:
                search: acunskis
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                [
                  {
                    "id": 2,
                    "username": "acunskis"
                  }
                ]
          - request:
              path: /api/v4/users
              method: GET
              query_params:
                search: jane_smith
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                [
                  {
                    "id": 3,
                    "username": "jane_smith"
                  }
                ]
        YAML
      end

      def milestone_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/milestones
              query_params:
                title: "0.0.1"
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                [
                  {
                    "id": 1
                  }
                ]
        YAML
      end

      def create_branch_mock
        <<~YAML
          - request:
              path: /api/v4/projects/#{project_name}/repository/branches
              method: POST
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: "[]"
        YAML
      end

      def labels_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/labels
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                [
                  {
                    "id": 15387018,
                    "name": "dependencies"
                  },
                  {
                    "id": 15387019,
                    "name": "ruby"
                  }
                ]
        YAML
      end

      def mr_check_mock
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/merge_requests
              query_params:
                state: closed
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: "[]"
        YAML
      end

      def no_branch_mock(dependency:)
        <<~YAML
          - request:
              method: GET
              path:
                matcher: ShouldStartWith
                value: /api/v4/projects/#{project_name}/repository/branches/dependabot-bundler-#{dependency}
            response:
              status: 404
              headers:
                Content-Type: application/json
              body: |
                {
                  "message": "404 Branch Not Found"
                }
        YAML
      end

      def branch_mock(dependency:)
        <<~YAML
          - request:
              method: GET
              path:
                matcher: ShouldStartWith
                value: /api/v4/projects/#{project_name}/repository/branches/dependabot-bundler-#{dependency}
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "name": "dependabot-bundler-#{dependency}"
                }
        YAML
      end

      def create_commits_mock(dependency:)
        <<~YAML
          - request:
              method: POST
              path: /api/v4/projects/#{project_name}/repository/commits
              body:
                matcher: ShouldMatch
                value: ^branch=dependabot-bundler-#{dependency}.*
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: "[]"
        YAML
      end

      def mr_mock(iid:, update_to:)
        <<~YAML
          - request:
              method: GET
              path: /api/v4/projects/#{project_name}/merge_requests/#{iid}
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "state": "opened",
                  "source_branch": "dependabot-bundler-#{update_to}",
                  "target_branch": "main",
                  "web_url": "#{AppConfig.gitlab_url}/#{project_name}/-/merge_requests/#{iid}"
                }
        YAML
      end

      def find_mr_mock(dependency:, id:, iid:, has_conflicts: true)
        <<~YAML
          - request:
              path: /api/v4/projects/#{project_name}/merge_requests
              method: GET
              query_params:
                source_branch:
                  matcher: ShouldStartWith
                  value: dependabot-bundler-#{dependency}
                state:
                  matcher: ShouldNotEqual
                  value: closed
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                [
                  {
                    "id": #{id},
                    "iid": #{iid},
                    "project_id": 32058529,
                    "web_url": "#{AppConfig.gitlab_url}/#{project_name}/-/merge_requests/#{iid}",
                    "reference": "!#{iid}",
                    "references": {
                      "short": "!#{iid}",
                      "relative": "!#{iid}",
                      "full": "#{project_name}!#{iid}"
                    },
                    "sha": "bd101cbfe6c71201abdb03e3193766de42f64560",
                    "has_conflicts": #{has_conflicts}
                  }
                ]
        YAML
      end

      def create_mr_mock(dependency:, iid: 1)
        <<~YAML
          - request:
              path: /api/v4/projects/#{project_name}/merge_requests
              method: POST
              body:
                matcher: ShouldContainSubstring
                value: source_branch=dependabot-bundler-#{dependency}
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "id": #{Faker::Number.number(digits: 10)},
                  "iid": #{iid},
                  "project_id": 32058529,
                  "web_url": "#{AppConfig.gitlab_url}/#{project_name}/-/merge_requests/#{iid}",
                  "reference": "!#{iid}",
                  "references": {
                    "short": "!#{iid}",
                    "relative": "!#{iid}",
                    "full": "#{project_name}!#{iid}"
                  }
                }
        YAML
      end

      def rebase_mock(iid:)
        <<~YAML
          - request:
              path: /api/v4/projects/#{project_name}/merge_requests/#{iid}/rebase
              method: PUT
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: ""
        YAML
      end
    end

    module Github
      def vulnerability(db_id:, package:, index: true)
        <<~YAML
          - request:
              path: /graphql
              method: POST
              body:
                matcher: ShouldContainSubstring
                value: "securityVulnerabilities(first: 100, ecosystem: $package_ecosystem#{index ? '' : ', after: $end_cursor'})"
            response:
              status: 200
              headers:
                Content-Type: application/json
              body: |
                {
                  "data": {
                    "securityVulnerabilities": {
                      "pageInfo": {
                        "endCursor": "Y3Vyc29yOnYyOpK5MjAyMi0wNC0xMlQwMzowNzozNSswMzowMM1Z9Q==",
                        "hasNextPage": #{index}
                      },
                      "nodes": [
                        {
                          "advisory": {
                            "databaseId": #{db_id},
                            "summary": "Improper Certificate Validation",
                            "description": "description",
                            "permalink": "https://github.com/advisories/GHSA-7mfr-774f-w5r9",
                            "origin": "UNSPECIFIED",
                            "publishedAt": "2022-04-12T00:07:34Z",
                            "withdrawnAt": null,
                            "references": [
                              {
                                "url": "https://nvd.nist.gov/vuln/detail/CVE-2017-11770"
                              }
                            ],
                            "identifiers": [
                              {
                                "value": "CVE-2017-11770"
                              }
                            ]
                          },
                          "firstPatchedVersion": {
                            "identifier": "2.0.3"
                          },
                          "package": {
                            "name": "#{package}"
                          },
                          "severity": "HIGH",
                          "vulnerableVersionRange": ">= 1.0.0, < 2.0.3"
                        }
                      ]
                    }
                  }
                }
        YAML
      end
    end
  end
end
