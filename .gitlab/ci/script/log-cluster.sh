#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

log "Save pod status"
kubectl get pods --namespace "$NAMESPACE" > tmp/pods.out

log "Save container logs"
kubectl logs \
  --selector "app.kubernetes.io/name=dependabot-gitlab" \
  --namespace "$NAMESPACE" \
  --since-time "$CI_JOB_STARTED_AT" \
  --prefix \
  --all-containers > tmp/containers.out
