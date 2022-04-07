#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

log "Registering project 'deploy-test'"
expected_response=\
'{
  "id": 1,
  "name": "deploy-test",
  "forked_from_id": null,
  "forked_from_name": null,
  "webhook_id": 1,
  "web_url": "https://example.com/deploy-test",
  "config": [
    {
      "reject_external_code": false,
      "package_manager": "bundler",
      "package_ecosystem": "bundler",
      "directory": "/",
      "registries": "*",
      "open_merge_requests_limit": 5,
      "branch_name_prefix": "dependabot",
      "branch_name_separator": "-",
      "allow": [
        {
          "dependency_type": "direct"
        }
      ],
      "ignore": [],
      "cron": "29 15 * * * UTC",
      "rebase_strategy": {
        "strategy": "auto"
      }
    }
  ]
}'

response=$(curl -X POST -s "docker:3000/api/projects" -H 'Content-Type: application/json' -d '{"project":"deploy-test"}' | jq)

if [[ "$response" == "$expected_response" ]]; then
  log_success "Successfully registered project!"
else
  log_error "Project registration unsuccessful!"
  echo "Expected response:"
  echo "$expected_response"
  echo "Actual response:"
  echo "$response"
  exit 1
fi
