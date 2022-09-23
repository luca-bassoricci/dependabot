#/bin/bash

# Build script for image building on CI

set -e

source "$(dirname "$0")/utils.sh"

core_version="$(dependabot_version)"
image="$CI_REGISTRY_IMAGE/dev"
latest_tag="${LATEST_TAG:-${CI_COMMIT_REF_SLUG}-latest}"
images="${image}:${CURRENT_TAG},${image}:${latest_tag}"

if [[ "$BUILD_PLATFORM" =~ arm64 ]]; then
  core_image="$CI_REGISTRY_IMAGE/core:v${core_version}"
else
  core_image="dependabot/dependabot-core:${core_version}"
fi

log_with_header "Building image '${image}:${CURRENT_TAG}'"
docker buildx build \
  --platform="$BUILD_PLATFORM" \
  --build-arg COMMIT_SHA="$CI_COMMIT_SHA" \
  --build-arg PROJECT_URL="$CI_PROJECT_URL" \
  --build-arg VERSION="${CI_COMMIT_TAG:-$CURRENT_TAG}" \
  --build-arg CORE_IMAGE="$core_image" \
  --output type=image,\"name="$images"\",push=true \
  --cache-from type=registry,ref="${image}:latest" \
  --cache-from type=registry,ref="${image}:${latest_tag}" \
  --cache-to type=inline \
  .
