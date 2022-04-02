# frozen_string_literal: true

module Support
  module Mocks
    def project_mock
      <<~YML
        - request:
            method: GET
            path:
              matcher: ShouldMatch
              value: /api/v4/projects/([a-z]+)$
          response:
            status: 200
            headers:
              Content-Type: application/json
            body: |
              {
                "id": #{Faker::Number.number(digits: 10)},
                "description": "Project for system tests",
                "default_branch": "main",
                "web_url": "https://gitlab.com/testing"
              }
      YML
    end

    def hook_mock
      @hook_mock ||= <<~YML
        - request:
            method: GET
            path:
              matcher: ShouldMatch
              value: /api/v4/projects/([a-z]+)/hooks
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
            path:
              matcher: ShouldMatch
              value: /api/v4/projects/([a-z]+)/hooks
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

    def config_check_mock
      @config_check_mock ||= <<~YAML
        - request:
            method: GET
            path:
              matcher: ShouldMatch
              value: /api/v4/projects/([a-z]+)/repository/files/.gitlab%2Fdependabot.yml
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

    def config_file_mock
      @config_file_mock ||= <<~YAML
        - request:
            method: GET
            path:
              matcher: ShouldMatch
              value: /api/v4/projects/([a-z]+)/repository/files/.gitlab%2Fdependabot.yml/raw
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
  end
end
