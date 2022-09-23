#/bin/sh

# Build script for image building on CI

set -e

source "$(dirname "$0")/utils.sh"

image="$CI_REGISTRY_IMAGE/dev"
latest_tag="${LATEST_TAG:-$CI_COMMIT_REF_SLUG-latest}"
core_version="$(dependabot_version)"

if [ -z "$CI_COMMIT_TAG" ]; then
  images="${image}:${CURRENT_TAG},${image}:${latest_tag}"
  core_image="dependabot/dependabot-core:${core_version}"
  platform="linux/amd64"
else
  images="${image}:${CURRENT_TAG}"
  core_image="$CI_REGISTRY_IMAGE/core:v${core_version}"
  platform="linux/amd64,linux/arm64"
fi

log_with_header "Building image '${image}:${CURRENT_TAG}'"

docker buildx build \
  --platform="$platform" \
  --build-arg COMMIT_SHA="$CI_COMMIT_SHA" \
  --build-arg PROJECT_URL="$CI_PROJECT_URL" \
  --build-arg VERSION="${CI_COMMIT_TAG:-$CURRENT_TAG}" \
  --build-arg CORE_IMAGE="$core_image" \
  --output type=image,\"name="$images"\",push=true \
  --cache-from type=registry,ref="${image}:latest" \
  --cache-from type=registry,ref="${image}:${latest_tag}" \
  --cache-to type=inline \
  .
