#/bin/sh

# Build script for image building on CI

cmd=$1
path=$2
image=$3
addr=$([ "$cmd" == "buildctl" ] && echo "--addr tcp://buildkit-service.gitlab.svc.cluster.local:1234" || echo "")

$cmd $addr build \
  --frontend=dockerfile.v0 \
  --local context="$path" \
  --local dockerfile="$path" \
  --opt build-arg:COMMIT_SHA="$CI_COMMIT_SHA" \
  --opt build-arg:PROJECT_URL="$CI_PROJECT_URL" \
  --export-cache type=inline \
  --import-cache type=registry,ref="$image":master-latest \
  --import-cache type=registry,ref="$image:$LATEST_TAG" \
  --output type=image,\"name="$image:$CURRENT_TAG","$image:$LATEST_TAG"\",push=true
