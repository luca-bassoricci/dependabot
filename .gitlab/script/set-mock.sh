#!/bin/bash

mocks="$(cat /build/spec/fixture/gitlab/mocks/gitlab-mock-$1.yml)"
curl -s -X POST \
  --header "content-type: application/x-yaml" \
  --data "$mocks" \
  "gitlab:8081/mocks?reset=true"
