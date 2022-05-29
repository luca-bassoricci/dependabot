#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

network="dependabot"

log_with_header "Setup gitlab mock"
log "** Creating '${network}' network **"
docker network create $network

log "** Pulling image '${MOCK_IMAGE}' **"
docker pull --quiet $MOCK_IMAGE

log "** Starting gitlab mock service **"
docker run -d \
  --network $network \
  --name gitlab \
  -p 8080:8080 \
  -p 8081:8081 \
  ${MOCK_IMAGE}

log "** Setting mock expectations **"
script/set-mock.sh standalone docker

log_with_header "Running standalone dependency updates"
log "** Pulling image '${APP_IMAGE}' **"
docker pull --quiet $APP_IMAGE

log "** Running rake task 'dependabot:update[dependabot-gitlab/testing,bundler,/]' **"
docker run --rm -i \
  -e RAILS_ENV=production \
  -e SETTINGS__GITLAB_URL=http://gitlab:8080 \
  -e SETTINGS__GITLAB_ACCESS_TOKEN=e2e-test \
  -e SETTINGS__GITHUB_ACCESS_TOKEN="${GITHUB_ACCESS_TOKEN_TEST:-}" \
  -e SETTINGS__STANDALONE=true \
  -e SETTINGS__LOG_LEVEL=debug \
  -e SETTINGS__LOG_COLOR=true \
  --network $network \
  $APP_IMAGE \
  rake 'dependabot:update[dependabot-gitlab/testing,bundler,/]'
