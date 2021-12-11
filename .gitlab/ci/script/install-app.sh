#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

app_name=dependabot

log "Installing dependabot-gitlab chart ${CHART_VERSION}"
helm install dependabot dependabot-gitlab \
  --values .gitlab/ci/helm/values.yml \
  --set "image.tag=${CURRENT_TAG}" \
  --set "env.gitlabUrl=http://gitlab.${NAMESPACE}.svc.cluster.local:4567" \
  --set "fullnameOverride=${app_name}" \
  --repo https://dependabot-gitlab.gitlab.io/chart \
  --namespace "$NAMESPACE" \
  --version "$CHART_VERSION" \
  --dependency-update \
  --timeout 10m \
  --wait \
  --wait-for-jobs
