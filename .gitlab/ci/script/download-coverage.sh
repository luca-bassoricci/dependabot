#/bin/bash

# COVERAGE uploader download script

set -e

source "$(dirname "$0")/utils.sh"

EXECUTABLE_CODACY="codacy-coverage-reporter-${CODACY_VERSION}"
EXECUTABLE_CODECOV="codecov-${CODECOV_VERSION}"

if [[ (-f "$EXECUTABLE_CODACY") && (-f "$EXECUTABLE_CODECOV") ]]; then
  log "Coverage uploaders present!"
fi

if [ ! -f "$EXECUTABLE_CODACY" ]; then
  log "Downloading codacy coverage reporter"
  curl -L -o "$EXECUTABLE_CODACY" "https://github.com/codacy/codacy-coverage-reporter/releases/download/${CODACY_VERSION}/codacy-coverage-reporter-linux"
  chmod +x "$EXECUTABLE_CODACY"
fi

if [ ! -f "$EXECUTABLE_CODECOV" ]; then
  log "Downloading codecov uploader"
  curl -L -o "$EXECUTABLE_CODECOV" "https://github.com/codecov/uploader/releases/download/v${CODECOV_VERSION}/codecov-linux"
  chmod +x "$EXECUTABLE_CODECOV"
fi
