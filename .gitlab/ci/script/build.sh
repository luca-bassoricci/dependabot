#/bin/sh

# Build script for image building on CI

source "$(dirname "$0")/utils.sh"

if [ -z "$DOCKER_IMAGE" ]; then
  IMAGE="$CI_REGISTRY_IMAGE"
else
  IMAGE="$CI_REGISTRY_IMAGE/$DOCKER_IMAGE"
fi

if [ ! -z "$BUILDKIT_ADDRESS" ]; then
  COMMAND="buildctl --addr tcp://${BUILDKIT_ADDRESS} --tlskey ${BUILDKIT_KEY} --tlscert ${BUILDKIT_CERT} --tlscacert ${BUILDKIT_CA}"
else
  COMMAND="buildctl-daemonless.sh"
fi

if [ -z "$CI_COMMIT_TAG" ]; then
  TAGS="$IMAGE:$CURRENT_TAG,$IMAGE:${LATEST_TAG:-$CI_COMMIT_REF_SLUG-latest}"
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
