#/bin/sh

# Build script for image building on CI

function log() {
  echo -e "\033[1;33m$1\033[0m"
}

if [ -z "$DOCKER_IMAGE" ]; then
  IMAGE="$CI_REGISTRY_IMAGE"
else
  IMAGE="$CI_REGISTRY_IMAGE/$DOCKER_IMAGE"
fi

if [[ "$FORK" != "true" && "$BUILDKIT_SERVICE" != "" ]]; then
  COMMAND="buildctl --addr tcp://${BUILDKIT_SERVICE}"
else
  COMMAND="buildctl-daemonless.sh"
fi

log "Building image: $IMAGE:$CURRENT_TAG"

$COMMAND build \
  --frontend=dockerfile.v0 \
  --local context="$DOCKER_CONTEXT" \
  --local dockerfile="$DOCKER_CONTEXT" \
  --opt build-arg:COMMIT_SHA="$CI_COMMIT_SHA" \
  --opt build-arg:PROJECT_URL="$CI_PROJECT_URL" \
  --opt build-arg:VERSION="$CURRENT_TAG" \
  --output type=image,\"name="$IMAGE:$CURRENT_TAG,$IMAGE:$LATEST_TAG"\",push="$PUSH"
