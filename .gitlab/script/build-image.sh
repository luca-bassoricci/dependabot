#/bin/sh

# Build script for image building on CI

set -e

source "$(dirname "$0")/utils.sh"

image_type="$1"

image="$CI_REGISTRY_IMAGE/dev/$image_type"
context="${DOCKER_CONTEXT:-.}"
dockerfile="${DOCKER_FILE:-$context}"
latest_tag="${LATEST_TAG:-$CI_COMMIT_REF_SLUG-latest}"
core_version="$(awk '/dependabot-omnibus \([0-9.]+\)/ {print $2}' Gemfile.lock | sed 's/[()]//g')"

if [ -z "$CI_COMMIT_TAG" ]; then
  images="${image}:${CURRENT_TAG},${image}:${latest_tag}"
else
  images="${image}:${CURRENT_TAG}"
fi

log "Building image '${image}:${CURRENT_TAG}'"

buildctl-daemonless.sh build \
  --frontend=dockerfile.v0 \
  --local context="$context" \
  --local dockerfile="$dockerfile" \
  --opt build-arg:COMMIT_SHA="$CI_COMMIT_SHA" \
  --opt build-arg:PROJECT_URL="$CI_PROJECT_URL" \
  --opt build-arg:VERSION="${CI_COMMIT_TAG:-$CURRENT_TAG}" \
  --opt build-arg:CORE_VERSION="$core_version" \
  --output type=image,\"name="$images"\",push=true \
  --import-cache type=registry,ref="${image}:latest" \
  --import-cache type=registry,ref="${image}:${latest_tag}" \
  --export-cache type=inline
