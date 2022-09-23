ARG CORE_IMAGE=dependabot/dependabot-core:latest

FROM ${CORE_IMAGE} as core

FROM core as development

ARG CODE_DIR=${HOME}/app
WORKDIR ${CODE_DIR}

ENV BUNDLE_PATH=${HOME}/.bundle \
    BUNDLE_BIN=${HOME}/.bundle/bin

# Create directory for volume containing VS Code extensions, to avoid reinstalling on image rebuilds
RUN mkdir -p "${HOME}/.vscode-server"

# Copy gemfile first so cache can be reused
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/
RUN bundle install

FROM core as production

USER root

ARG JEMALLOC_VERSION=5.3.0
ARG JEMALLOC_DOWNLOAD_URL="https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2"
RUN set -eux; \
    apt-get update \
    && apt-get install -y --no-install-recommends autoconf \
    && rm -rf /var/lib/apt/lists/*; \
    \
    mkdir -p /usr/src/jemalloc \
    && cd /usr/src/jemalloc \
    && curl --fail --location --output jemalloc.tar.bz2 ${JEMALLOC_DOWNLOAD_URL}; \
    \
    tar -xjf jemalloc.tar.bz2 && cd jemalloc-${JEMALLOC_VERSION}; \
    ./autogen.sh --prefix=/usr && make -j "$(nproc)" install; \
    \
    rm -rf jemalloc.tar.bz2

USER dependabot

WORKDIR /home/dependabot/app

ENV BUNDLE_PATH=vendor/bundle \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD=/usr/lib/libjemalloc.so \
    RAILS_ENV=production

# Copy gemfile first so cache can be reused
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=dependabot:dependabot ./ ./

# Smoke test image
RUN SETTINGS__GITLAB_ACCESS_TOKEN=token bundle exec rake about

ARG COMMIT_SHA
ARG PROJECT_URL
ARG VERSION

ENV APP_VERSION=$VERSION

LABEL maintainer="andrejs.cunskis@gmail.com" \
    vcs-ref=$COMMIT_SHA \
    vcs-url=$PROJECT_URL \
    version=$VERSION

ENTRYPOINT [ "bundle", "exec" ]
