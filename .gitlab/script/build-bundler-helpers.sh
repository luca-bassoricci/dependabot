#!/bin/bash

set -e

source "$(dirname "$0")/utils.sh"

core_version="$(bundle info dependabot-omnibus | grep -oP '\(\K[0-9.]+')"
core_tgz="tmp/dependabot.tar.gz"

log "Fetch native bundler helpers"
curl --fail --location --output $core_tgz \
  "https://github.com/dependabot/dependabot-core/archive/refs/tags/v${core_version}.tar.gz" && \
  \
  tar -C tmp -xzf $core_tgz dependabot-core-${core_version}/bundler/helpers

log "Build native bundler helpers"
DEPENDABOT_NATIVE_HELPERS_PATH="helpers" bash tmp/dependabot-core-${core_version}/bundler/helpers/v2/build

log "Cleanup"
rm -rf $core_tgz tmp/dependabot-core-${core_version}
