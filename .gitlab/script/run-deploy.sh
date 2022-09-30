#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

log_with_header "Setting up dependabot app"
log "** Pulling docker images **"
docker compose pull --quiet --include-deps

log "** Starting app **"
docker compose up --wait redis mongodb web worker

log_with_header "Setting up gitlab mock"
log "** Pulling image '${MOCK_IMAGE}' **"
docker pull --quiet $MOCK_IMAGE

log "** Starting gitlab mock service **"
docker run -d \
  --network "${COMPOSE_PROJECT_NAME}_default" \
  --name gitlab \
  -p 8080:8080 \
  -p 8081:8081 \
  ${MOCK_IMAGE}

log "** Setting mock expectations **"
script/set-mock.sh deploy docker
