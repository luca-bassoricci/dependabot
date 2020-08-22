FROM dependabot/dependabot-core:0.118.16

ENV BUNDLE_PATH=vendor/bundle \
  BUNDLE_WITHOUT="development:test"

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    supervisor=3.3.1-1.1; \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN useradd --uid 1000 --create-home -s /bin/bash dependabot
RUN gem install bundler -v 2.0.2 --no-document

WORKDIR /home/dependabot

USER dependabot

# Copy gemfile first so cache can be reused
COPY --chown=1000:1000 Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=1000:1000 ./ ./

ARG COMMIT_SHA
ARG PROJECT_URL

LABEL maintainer="andrejs.cunskis@gmail.com" \
      vcs-ref=$COMMIT_SHA \
      vcs-url=$PROJECT_URL

EXPOSE 3000

ENTRYPOINT [ "bundle", "exec" ]
