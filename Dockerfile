ARG BUNDLER_VERSION=2.0.2

FROM dependabot/dependabot-core:0.124.2 AS dependabot

FROM dependabot AS development

ARG BUNDLER_VERSION

ENV BUNDLE_PATH=/vendor/bundle

RUN apt-get update && apt-get install -y --no-install-recommends supervisor=3.3.1-1.1; \
    gem install bundler -v ${BUNDLER_VERSION} --no-document; \
    rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /code

ENTRYPOINT [ "/bin/bash", "-c" ]

FROM dependabot AS production

ARG BUNDLER_VERSION

ENV BUNDLE_PATH=vendor/bundle \
    BUNDLE_WITHOUT="development:test"

RUN useradd --uid 1000 --create-home -s /bin/bash dependabot; \
    chown -R dependabot:dependabot /opt
RUN gem install bundler -v ${BUNDLER_VERSION} --no-document

WORKDIR /home/dependabot

USER dependabot

# Copy gemfile first so cache can be reused
COPY --chown=1000:1000 Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=1000:1000 ./ ./

EXPOSE 3000

ARG COMMIT_SHA
ARG PROJECT_URL

LABEL maintainer="andrejs.cunskis@gmail.com" \
      vcs-ref=$COMMIT_SHA \
      vcs-url=$PROJECT_URL

ENTRYPOINT [ "bundle", "exec" ]
