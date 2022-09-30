#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

release_image="registry.gitlab.com/dependabot-gitlab/dependabot:latest"

log "** Pulling docker images **"
docker compose pull --quiet --include-deps
docker pull --quiet "$release_image"

log "** Initializing database from latest release **"
APP_IMAGE="$release_image" docker compose run --rm migration

log "** Running seed data **"
docker compose run --rm migration bundle exec rake db:seed

log "** Running migrations **"
docker compose run --rm migration
