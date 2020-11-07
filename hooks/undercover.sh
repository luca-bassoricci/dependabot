#!/bin/sh

set -e

cov="coverage/dependabot.lcov"

echo "Fetch latest coverage data"
curl --silent --show-error --fail --location --output "$cov" \
  https://gitlab.com/dependabot-gitlab/dependabot/-/jobs/artifacts/master/raw/coverage/dependabot.lcov\?job\=tests

echo "Run undercover"
bundle exec undercover -l "$cov"
