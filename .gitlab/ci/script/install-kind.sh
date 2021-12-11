#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

log "Wait for docker"
for i in $(seq 1 30); do
  if ! docker info &>/dev/null; then
    echo "Docker not responding yet. Sleeping for 2s..." && sleep 2s
  else
    echo "Docker ready. Continuing build..."
    break
  fi
done

log "Setup kind cluster"
kind create cluster --config .gitlab/ci/kube/kind-config.yaml
sed -i -E -e "s/localhost|0\.0\.0\.0/docker/g" "${HOME}/.kube/config"

log "Deploy gitlab mock"
kubectl create namespace "$NAMESPACE"
kubectl apply -f .gitlab/ci/kube/fake-gitlab.yaml -n "$NAMESPACE"
