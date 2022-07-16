#!/bin/bash

set -e

source "$(dirname "$0")/utils.sh"

core_version="$(dependabot_version)"
core_tgz="tmp/dependabot.tar.gz"
helpers=("$@")

log_with_header "Setting up native build helpers v${core_version}"
log "** Downloading native helpers **"
curl -s --fail --location --output $core_tgz \
  "https://github.com/dependabot/dependabot-core/archive/refs/tags/v${core_version}.tar.gz"
log_success "success!\n"

log "** Extracting native helpers **"
for helper in "${helpers[@]}"; do
  log_info "extracting $helper"
  tar -C tmp -xzf $core_tgz dependabot-core-${core_version}/${helper}/helpers
done
log_success "success!\n"

log "** Building native helpers **"
export DEPENDABOT_NATIVE_HELPERS_PATH="helpers"
for helper in "${helpers[@]}"; do
  log_info "building $helper"

  if [ "$helper" == "bundler" ]; then
    path=tmp/dependabot-core-${core_version}/${helper}/helpers/v2/build
  else
    path=tmp/dependabot-core-${core_version}/${helper}/helpers/build
  fi

  bash $path
  log_info "done!"
  echo
done
log_success "success!"

rm -rf $core_tgz tmp/dependabot-core-${core_version}
