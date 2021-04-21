FROM dependabot/dependabot-core:0.143.1 AS dependabot

FROM dependabot AS local

ENV BUNDLE_PATH=/vendor/bundle

RUN apt-get update; \
    apt-get install -y --no-install-recommends supervisor=3.3.1-1.1; \
    rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /code

ENTRYPOINT [ "/bin/bash", "-c" ]

FROM dependabot AS production

ENV BUNDLE_PATH=vendor/bundle \
    BUNDLE_WITHOUT="development:test"

USER dependabot

WORKDIR /home/dependabot/app

# Copy gemfile first so cache can be reused
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=dependabot:dependabot ./ ./

# Smoke test image
RUN SETTINGS__GITLAB_ACCESS_TOKEN=token RAILS_ENV=production \
    bundle exec rake about

ARG COMMIT_SHA
ARG PROJECT_URL

LABEL maintainer="andrejs.cunskis@gmail.com" \
      vcs-ref=$COMMIT_SHA \
      vcs-url=$PROJECT_URL

ENTRYPOINT [ "bundle", "exec" ]
