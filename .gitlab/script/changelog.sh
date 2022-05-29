#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

changelog_endpoint="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/repository/changelog"
header="PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}"

release_version=$(echo ${CI_COMMIT_TAG} | grep -oP 'v\K[0-9.]+')
data="version=${release_version}&trailer=changelog"

log_info "Fetching release notes"
curl -s --header "${header}" "${changelog_endpoint}?${data}" | jq -r ".notes" > ${RELEASE_NOTES_FILE}
log_success "done!"

log_info "Updating CHANGELOG.md"
curl -X POST -s --header "${header}" --data "${data}" "${changelog_endpoint}"
log_success "done!"
