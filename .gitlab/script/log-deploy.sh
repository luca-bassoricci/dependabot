#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_with_header "web container logs"
docker compose logs --no-log-prefix web

log_with_header "worker container logs"
docker compose logs --no-log-prefix worker
