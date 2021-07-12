#/bin/bash

# Codacy download script

set -e

EXECUTABLE="codacy-coverage-reporter-${CODACY_VERSION}"

if [ -f "$EXECUTABLE" ]; then
  echo "$EXECUTABLE is already present"
  exit
fi

curl -L -o "$EXECUTABLE" "https://github.com/codacy/codacy-coverage-reporter/releases/download/${CODACY_VERSION}/codacy-coverage-reporter-linux"
chmod +x "$EXECUTABLE"
