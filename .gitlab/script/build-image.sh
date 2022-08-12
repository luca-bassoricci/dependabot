#/bin/sh

# Build script for image building on CI

set -e

source "$(dirname "$0")/utils.sh"

image="$CI_REGISTRY_IMAGE/dev"
latest_tag="${LATEST_TAG:-$CI_COMMIT_REF_SLUG-latest}"
core_version="$(dependabot_version)"
platform="${TARGET_PLATFORM:-linux/amd64}"

if [ -z "$CI_COMMIT_TAG" ]; then
  images="${image}:${CURRENT_TAG},${image}:${latest_tag}"
else
  images="${image}:${CURRENT_TAG}"
fi

log_with_header "Building image '${image}:${CURRENT_TAG}'"

buildctl-daemonless.sh build \
  --frontend=dockerfile.v0 \
  --local context=. \
  --local dockerfile=. \
  --opt platform="$platform" \
  --opt build-arg:COMMIT_SHA="$CI_COMMIT_SHA" \
  --opt build-arg:PROJECT_URL="$CI_PROJECT_URL" \
  --opt build-arg:VERSION="${CI_COMMIT_TAG:-$CURRENT_TAG}" \
  --opt build-arg:CORE_VERSION="$core_version" \
  --output type=image,\"name="$images"\",push=true \
  --import-cache type=registry,ref="${image}:latest" \
  --import-cache type=registry,ref="${image}:${latest_tag}" \
  --export-cache type=inline
