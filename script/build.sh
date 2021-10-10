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

if [ ! -z "$DEPENDABOT_HOST" ]; then
  COMMAND="buildctl --addr tcp://buildkit.${DEPENDABOT_HOST}:1234"
else
  COMMAND="buildctl-daemonless.sh"
fi

if [ -z "$CI_COMMIT_TAG" ]; then
  TAGS="$IMAGE:$CURRENT_TAG,$IMAGE:$LATEST_TAG"
else
  TAGS="$IMAGE:$CURRENT_TAG"
fi

log "Building image: $IMAGE:$CURRENT_TAG"

$COMMAND build \
  --frontend=dockerfile.v0 \
  --local context="$DOCKER_CONTEXT" \
  --local dockerfile="$DOCKER_CONTEXT" \
  --opt build-arg:COMMIT_SHA="$CI_COMMIT_SHA" \
  --opt build-arg:PROJECT_URL="$CI_PROJECT_URL" \
  --opt build-arg:VERSION="${CI_COMMIT_TAG:-$CURRENT_TAG}" \
  --output type=image,\"name="$TAGS"\",push="$PUSH"
