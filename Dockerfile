FROM dependabot/dependabot-core:0.183.0 as core

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

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libjemalloc-dev=5.2.1-1ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

USER dependabot

WORKDIR /home/dependabot/app

ENV BUNDLE_PATH=vendor/bundle \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so

# Copy gemfile first so cache can be reused
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=dependabot:dependabot ./ ./

# Smoke test image
RUN SETTINGS__GITLAB_ACCESS_TOKEN=token \
    RAILS_ENV=production \
    bundle exec rake about

ARG COMMIT_SHA
ARG PROJECT_URL
ARG VERSION

ENV APP_VERSION=$VERSION

LABEL maintainer="andrejs.cunskis@gmail.com" \
    vcs-ref=$COMMIT_SHA \
    vcs-url=$PROJECT_URL \
    version=$VERSION

ENTRYPOINT [ "bundle", "exec" ]
