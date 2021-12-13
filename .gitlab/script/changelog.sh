#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/utils.sh"

changelog_endpoint="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/repository/changelog"
header="PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}"

release_version=$(echo ${CI_COMMIT_TAG} | grep -oP 'v\K[0-9.]+')
data="version=${release_version}&trailer=changelog"

log "Fetching release notes"
curl -s --header "${header}" "${changelog_endpoint}?${data}" | jq -r ".notes" > ${RELEASE_NOTES_FILE}
cat ${RELEASE_NOTES_FILE}

log "Updating CHANGELOG.md"
curl -X POST --header "${header}" --data "${data}" "${changelog_endpoint}"
