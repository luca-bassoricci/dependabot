ARG BUNDLER_VERSION=2.0.2

FROM dependabot/dependabot-core:0.125.6 AS dependabot

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

RUN gem install bundler -v ${BUNDLER_VERSION} --no-document

WORKDIR /home/dependabot

# Copy gemfile first so cache can be reused
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY ./ ./

ARG COMMIT_SHA
ARG PROJECT_URL

LABEL maintainer="andrejs.cunskis@gmail.com" \
      vcs-ref=$COMMIT_SHA \
      vcs-url=$PROJECT_URL

ENTRYPOINT [ "bundle", "exec" ]
