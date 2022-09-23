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

function log_with_header() {
  length=$(echo "$1" | awk '{print length}')
  delimiter=$(head -c $length </dev/zero | tr '\0' "${2:-=}")

  log_info "$delimiter"
  log_info "$1"
  log_info "$delimiter"
}

function dependabot_version() {
  echo "$(awk '/dependabot-omnibus \([0-9.]+\)/ {print $2}' Gemfile.lock | sed 's/[()]//g')"
}

function install_qemu() {
  docker pull -q ${QEMU_IMAGE}
  docker run --rm --privileged ${QEMU_IMAGE} --uninstall qemu-*
  docker run --rm --privileged ${QEMU_IMAGE} --install all
}

function setup_buildx() {
  docker buildx create --use
}

function copy_image() {
  regctl image copy "${1}" "${2}" --verbosity info
}

function regctl_login() {
  regctl registry login "${1}" -u "${2}" -p "${3}" --verbosity info
}
