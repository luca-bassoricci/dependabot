#!/bin/bash

function log() {
  echo -e "\033[1;33m$1\033[0m"
}

function log_error() {
  echo -e "\033[1;31m$1\033[0m"
}

function log_success() {
  echo -e "\033[1;32m$1\033[0m"
}

function log_info() {
  echo -e "\033[1;35m$1\033[0m"
}

function dependabot_version() {
  echo "$(awk '/dependabot-omnibus \([0-9.]+\)/ {print $2}' Gemfile.lock | sed 's/[()]//g')"
}
