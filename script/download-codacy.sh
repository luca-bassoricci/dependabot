#/bin/bash

# Codacy download script

set -e

EXECUTABLE="codacy-coverage-reporter-${CODACY_VERSION}"

[ -f "$EXECUTABLE" ] && exit

apt-get update -q && apt-get install -y -q --no-install-recommends curl
curl -Ls -o "$EXECUTABLE" "https://dl.bintray.com/codacy/Binaries/${CODACY_VERSION}/codacy-coverage-reporter-linux"
chmod +x "$EXECUTABLE"
