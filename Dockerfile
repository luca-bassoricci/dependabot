FROM dependabot/dependabot-core:0.174.0 as core

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

ENV BUNDLE_PATH=vendor/bundle \
    BUNDLE_WITHOUT="development:test"

USER dependabot

WORKDIR /home/dependabot/app

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
