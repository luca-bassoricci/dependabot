#/bin/bash

# COVERAGE uploader download script

set -e

source "$(dirname "$0")/utils.sh"

EXECUTABLE_CODACY="codacy-coverage-reporter"

if [[ -f "$EXECUTABLE_CODACY" ]]; then
  log_success "Coverage uploader present!"
fi

if [ ! -f "$EXECUTABLE_CODACY" ]; then
  log_info "Downloading codacy coverage reporter v${CODACY_VERSION}"
  curl -L -o "$EXECUTABLE_CODACY" "https://github.com/codacy/codacy-coverage-reporter/releases/download/${CODACY_VERSION}/codacy-coverage-reporter-linux"
  chmod +x "$EXECUTABLE_CODACY"
  log_success "done!"
fi
