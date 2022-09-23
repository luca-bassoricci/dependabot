#/bin/sh

# Build script for image building on CI

set -e

source "$(dirname "$0")/utils.sh"

core_image_registry="${CI_REGISTRY_IMAGE}/core"
core_version="$(dependabot_version)"
core_image="dependabot/dependabot-core:${core_version}"
multi_arch_image="${core_image_registry}:v${core_version}" # use v prefix so images can be cleaned up and do not follow same pattern as releases
latest_multi_arch_image="${core_image_registry}:latest"
arm_image="${CI_REGISTRY_IMAGE}/dev:core-${core_version}-arm64" # store temp arm images in dev so they can be cleaned up

log_with_header "Building core image '${multi_arch_image}'"

log_info "Fetching core repo for version 'v${core_version}'"
git clone https://github.com/dependabot/dependabot-core.git \
  --branch "v${core_version}" \
  --depth 1 \
  --config advice.detachedHead=false

log_info "Building arm64 core image"
docker buildx build \
  --cache-from type=registry,ref="$latest_multi_arch_image" \
  --cache-to type=inline \
  --build-arg TARGETARCH=arm64 \
  --platform linux/arm64 \
  --tag "$arm_image" \
  --push \
  dependabot-core

log_info "Create multi-arch core image"
docker buildx imagetools create -t "$multi_arch_image" "$arm_image" "$core_image"
regctl_login "$CI_REGISTRY" "$CI_REGISTRY_USER" "$CI_REGISTRY_PASSWORD"
copy_image "$multi_arch_image" "$latest_multi_arch_image" # tag with latest
