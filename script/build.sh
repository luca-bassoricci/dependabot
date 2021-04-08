#/bin/sh

# Build script for image building on CI

args="--frontend=dockerfile.v0 \
--local context=$DOCKER_CONTEXT \
--local dockerfile=$DOCKER_CONTEXT \
--opt build-arg:COMMIT_SHA=$CI_COMMIT_SHA \
--opt build-arg:PROJECT_URL=$CI_PROJECT_URL \
--output type=image,\"name=$DOCKER_IMAGE:$CURRENT_TAG,$DOCKER_IMAGE:$LATEST_TAG\",push=$PUSH"

function build() {
  buildctl --addr tcp://buildkit-service.gitlab.svc.cluster.local:1234 build $args
}

function build_fork() {
  buildctl-daemonless.sh build $args --export-cache type=inline --import-cache type=registry,ref="$DOCKER_IMAGE:$LATEST_TAG"
}

[[ -z "$FORK" ]] || build_fork && build
