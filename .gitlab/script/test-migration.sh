#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

release_image="registry.gitlab.com/dependabot-gitlab/dependabot:latest"

log "** Pulling docker images **"
docker compose pull --quiet --include-deps 2>/dev/null
docker pull --quiet "$release_image"

log "** Initializing database from latest release **"
APP_IMAGE="$release_image" docker compose run --rm migration 2>/dev/null
APP_IMAGE="$release_image" docker compose run --rm migration bundle exec rake "db:seed" 2>/dev/null

log "** Running migrations **"
docker compose run --rm migration 2>/dev/null

log "** Validate no migrations are pending **"
docker compose run --rm migration bundle exec rake "dependabot:check_migrations" 2>/dev/null

log "** Running seed data **"
docker compose run --rm migration bundle exec rake "db:seed" 2>/dev/null
