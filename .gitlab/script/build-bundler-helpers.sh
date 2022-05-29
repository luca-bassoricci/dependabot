#!/bin/bash

set -e

source "$(dirname "$0")/utils.sh"

core_version="$(dependabot_version)"
core_tgz="tmp/dependabot.tar.gz"

log_with_header "Setting up native build helpers v${core_version}"
log "** Fetching native bundler helpers **"
curl -s --fail --location --output $core_tgz \
  "https://github.com/dependabot/dependabot-core/archive/refs/tags/v${core_version}.tar.gz" && \
  \
  tar -C tmp -xzf $core_tgz dependabot-core-${core_version}/bundler/helpers
log_success "done!"

log "** Building native bundler helpers **"
DEPENDABOT_NATIVE_HELPERS_PATH="helpers" bash tmp/dependabot-core-${core_version}/bundler/helpers/v2/build
rm -rf $core_tgz tmp/dependabot-core-${core_version}
log_success "done!"
