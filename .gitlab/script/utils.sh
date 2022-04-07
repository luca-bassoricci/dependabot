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
