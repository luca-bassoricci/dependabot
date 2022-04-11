#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

log "Setup gitlab mock"
cat <<"YML" | docker compose -f /dev/stdin up -d --quiet-pull
version: "3"

services:
  gitlab:
    image: ${MOCK_IMAGE}
    ports:
      - 8080:8080
      - 8081:8081

  setup:
    image: alpine/curl:3.14
    working_dir: /build
    depends_on:
      - gitlab
    volumes:
      - ${CI_PROJECT_DIR}:/build
    command: script/set-mock.sh standalone
YML

log "Run standalone dependency updates"
echo "** Pulling image '${APP_IMAGE}' **"
docker pull --quiet $APP_IMAGE

echo ""
echo "Running rake task 'dependabot:update[dependabot-gitlab/testing,bundler,/]'"
docker run --rm -i \
  -e RAILS_ENV=production \
  -e SETTINGS__GITLAB_URL=http://gitlab:8080 \
  -e SETTINGS__GITLAB_ACCESS_TOKEN=e2e-test \
  -e SETTINGS__GITHUB_ACCESS_TOKEN="${GITHUB_ACCESS_TOKEN_TEST:-}" \
  -e SETTINGS__STANDALONE=true \
  -e SETTINGS__LOG_LEVEL=debug \
  -e SETTINGS__LOG_COLOR=true \
  --network "${COMPOSE_PROJECT_NAME}_default" \
  $APP_IMAGE \
  rake 'dependabot:update[dependabot-gitlab/testing,bundler,/]'
