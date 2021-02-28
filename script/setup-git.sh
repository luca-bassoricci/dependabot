#/bin/sh

set -e

function log() {
  echo -e "\033[1;33m$1\033[0m"
}

log "Install ssh"
which ssh-agent || (apt-get update -qq && apt-get install openssh-client -qq)

log "Start ssh agent"
eval $(ssh-agent -s)

log "Add identity"
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -

log "Add github to known hosts"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan github.com >>~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts

log "Add git configuration"
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_USERNAME"
