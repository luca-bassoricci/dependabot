#/bin/sh

# Build script for image building on CI

path=$1
image=$2
args="--frontend=dockerfile.v0 \
--local context=$path \
--local dockerfile=$path \
--opt build-arg:COMMIT_SHA=$CI_COMMIT_SHA \
--opt build-arg:PROJECT_URL=$CI_PROJECT_URL \
--output type=image,\"name=$image:$CURRENT_TAG,$image:$LATEST_TAG\",push=true"

function build() {
  buildctl --addr tcp://buildkit-service.gitlab.svc.cluster.local:1234 build $args
}

function build_fork() {
  buildctl-daemonless.sh build $args --export-cache type=inline --import-cache type=registry,ref="$image:$LATEST_TAG"
}

[[ -z "$FORK" ]] || build_fork && build
