#!/bin/bash

# Script for image release on CI
#
set -e

source "$(dirname "$0")/utils.sh"

function tag_and_push() {
  registry=$1
  version=$2

  release_tag="$registry:$release_version"
  latest_tag="$registry:latest"

  docker tag "$APP_IMAGE" "$release_tag"
  docker tag "$APP_IMAGE" "$latest_tag"
  docker push "$release_tag"
  docker push "$latest_tag"
}

release_version="$(echo $CI_COMMIT_TAG | grep -oP 'v\K[0-9.]+')"

log_with_header "Pulling '${APP_IMAGE}'"
docker pull "$APP_IMAGE" -q

log_with_header "Tagging and pushing release to dockerhub"
tag_and_push "$DOCKERHUB" "$release_version"

log_with_header "Tagging and pushing release to gitlab registry"
tag_and_push "$GITLAB" "$release_version"
