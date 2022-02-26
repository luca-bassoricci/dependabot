#!/bin/sh

# Must be executed from project root

mocks="$(cat spec/fixture/gitlab/mocks/gitlab-mock-$1.yml)"
curl -s -X POST \
  --header "content-type: application/x-yaml" \
  --data "$mocks" \
  "gitlab:8081/mocks?reset=true"
