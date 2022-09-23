#!/bin/bash

# Script for image release on CI
#
set -e

source "$(dirname "$0")/utils.sh"

release_version="$(echo $CI_COMMIT_TAG | grep -oP 'v\K[0-9.]+')"

log_info "Authenticate to docker registries"
regctl_login "$CI_REGISTRY" "$CI_REGISTRY_USER" "$CI_REGISTRY_PASSWORD"
regctl_login "docker.io" "$DOCKERHUB_USERNAME" "$DOCKERHUB_PASSWORD"

log_info "Tagging and pushing release to dockerhub"
copy_image "${APP_IMAGE}" "${DOCKERHUB}:${release_version}"
copy_image "${APP_IMAGE}" "${DOCKERHUB}:latest"

log_info "Tagging and pushing release to gitlab registry"
copy_image "${APP_IMAGE}" "${GITLAB}:${release_version}"
copy_image "${APP_IMAGE}" "${GITLAB}:latest"
