#/bin/bash

# COVERAGE uploader download script

set -e

source "$(dirname "$0")/utils.sh"

EXECUTABLE_CODACY="codacy-coverage-reporter-${CODACY_VERSION}"

if [[ -f "$EXECUTABLE_CODACY" ]]; then
  log "Coverage uploaders present!"
fi

if [ ! -f "$EXECUTABLE_CODACY" ]; then
  log "Downloading codacy coverage reporter"
  curl -s -L -o "$EXECUTABLE_CODACY" "https://github.com/codacy/codacy-coverage-reporter/releases/download/${CODACY_VERSION}/codacy-coverage-reporter-linux"
  chmod +x "$EXECUTABLE_CODACY"
  log_success "done!"
fi
