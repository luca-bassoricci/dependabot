#/bin/sh

# Build script for image building on CI

set -e

source "$(dirname "$0")/utils.sh"

IMAGE="$CI_REGISTRY_IMAGE/$DOCKER_IMAGE"

if [ -z "$CI_COMMIT_TAG" ]; then
  TAGS="$IMAGE:$CURRENT_TAG,$IMAGE:${LATEST_TAG:-$CI_COMMIT_REF_SLUG-latest}"
else
  TAGS="$IMAGE:$CURRENT_TAG"
fi

context="${DOCKER_CONTEXT:-.}"
dockerfile="${DOCKER_FILE:-$context}"

log "Building image: $IMAGE:$CURRENT_TAG"

buildctl-daemonless.sh build \
  --frontend=dockerfile.v0 \
  --local context="$context" \
  --local dockerfile="$dockerfile" \
  --opt build-arg:COMMIT_SHA="$CI_COMMIT_SHA" \
  --opt build-arg:PROJECT_URL="$CI_PROJECT_URL" \
  --opt build-arg:VERSION="${CI_COMMIT_TAG:-$CURRENT_TAG}" \
  --output type=image,\"name="$TAGS"\",push=true \
  --export-cache type=inline \
  --import-cache type=registry,ref="$IMAGE:${LATEST_TAG:-$CI_COMMIT_REF_SLUG-latest}"
