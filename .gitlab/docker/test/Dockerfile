FROM ruby:2.7-slim-bullseye

ARG BUNDLER_VERSION=2.2.32

ENV BUNDLE_SUPPRESS_INSTALL_USING_MESSAGES="true"

RUN set -eux; \
  apt update && apt install -y --no-install-recommends \
  curl \
  jq \
  git \
  build-essential; \
  \
  gem install bundler -v ${BUNDLER_VERSION} --no-document
