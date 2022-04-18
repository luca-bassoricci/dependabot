#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

log "Setting up dependabot app"
log_info "** Pulling image '${APP_IMAGE}' **"
docker pull --quiet $APP_IMAGE

log_info "** Starting app **"
docker compose --ansi always up -d --quiet-pull

log "Setting up gitlab mock"
log_info "** Pulling image '${MOCK_IMAGE}' **"
docker pull --quiet $MOCK_IMAGE

log_info "** Starting gitlab mock service **"
docker run -d \
  --network "${COMPOSE_PROJECT_NAME}_default" \
  --name gitlab \
  -p 8080:8080 \
  -p 8081:8081 \
  ${MOCK_IMAGE}

log_info "** Setting mock expectations **"
script/set-mock.sh deploy docker

log "Waiting for dependabot to be ready"
timeout 30 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' docker:3000/healthcheck)" != "200" ]]; do sleep 2; done'
