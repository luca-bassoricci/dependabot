#!/bin/sh

# Must be executed from project root

mock="${1}"
host="${2:-gitlab}"

mocks="$(cat spec/fixture/gitlab/mocks/gitlab-mock-${mock}.yml)"
curl -s -X POST \
  --header "content-type: application/x-yaml" \
  --data "$mocks" \
  "http://${host}:8081/mocks?reset=true"
