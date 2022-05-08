#!/bin/bash

set -e

source "$(dirname "$0")/utils.sh"

core_version="$(dependabot_version)"
core_tgz="tmp/dependabot.tar.gz"

log "Setting up native build helpers v${core_version}"
log_info "** Fetching native bundler helpers **"
curl -s --fail --location --output $core_tgz \
  "https://github.com/dependabot/dependabot-core/archive/refs/tags/v${core_version}.tar.gz" && \
  \
  tar -C tmp -xzf $core_tgz dependabot-core-${core_version}/bundler/helpers
log_success "done!"

log_info "** Building native bundler helpers **"
DEPENDABOT_NATIVE_HELPERS_PATH="helpers" bash tmp/dependabot-core-${core_version}/bundler/helpers/v2/build
rm -rf $core_tgz tmp/dependabot-core-${core_version}
