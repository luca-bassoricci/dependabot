#!/bin/bash

# Script for image release on CI
#
set -e

source "$(dirname "$0")/utils.sh"

release_version="$(echo $CI_COMMIT_TAG | grep -oP 'v\K[0-9.]+')"

log_info "Tagging and pushing release to dockerhub"
docker buildx imagetools create -t "${APP_IMAGE}" "${DOCKERHUB_IMAGE}:${release_version}"
docker buildx imagetools create -t "${APP_IMAGE}" "${DOCKERHUB_IMAGE}:latest"

log_info "Tagging and pushing release to gitlab registry"
docker buildx imagetools create -t "${APP_IMAGE}" "${GITLAB_IMAGE}:${release_version}"
docker buildx imagetools create -t "${APP_IMAGE}" "${GITLAB_IMAGE}:latest"
