#/bin/sh

# Build script for image building on CI

function log() {
  echo -e "\033[1;33m$1\033[0m"
}

if [ -z "$DOCKER_IMAGE" ]; then
  IMAGE="$CI_REGISTRY_IMAGE"
  CACHE="$CI_REGISTRY_IMAGE/cache"
else
  IMAGE="$CI_REGISTRY_IMAGE/$DOCKER_IMAGE"
  CACHE="$CI_REGISTRY_IMAGE/cache/$DOCKER_IMAGE"
fi

log "Building image: $IMAGE:$CURRENT_TAG"

buildctl --addr tcp://buildkit:1234 build \
  --frontend=dockerfile.v0 \
  --local context="$DOCKER_CONTEXT" \
  --local dockerfile="$DOCKER_CONTEXT" \
  --opt build-arg:COMMIT_SHA="$CI_COMMIT_SHA" \
  --opt build-arg:PROJECT_URL="$CI_PROJECT_URL" \
  --export-cache type=inline \
  --import-cache type=registry,ref="$IMAGE:$LATEST_TAG" \
  --output type=image,\"name="$IMAGE:$CURRENT_TAG,$IMAGE:$LATEST_TAG"\",push="$PUSH"
