FROM dependabot/dependabot-core:0.118.5

ENV BUNDLE_PATH=vendor/bundle \
  BUNDLE_WITHOUT="development:test"

RUN useradd --uid 1000 --create-home -s /bin/bash dependabot
RUN gem install bundler -v 2.0.2 --no-document

WORKDIR /home/dependabot

USER dependabot

# Copy gemfile first so cache can be reused
COPY --chown=1000:1000 Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=1000:1000 ./ ./

ENTRYPOINT [ "bundle", "exec" ]
