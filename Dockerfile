FROM dependabot/dependabot-core:0.118.5

ENV BUNDLE_PATH=vendor/bundle \
  BUNDLE_WITHOUT="development:test"

WORKDIR /dependabot

RUN set -eux; \
  apt-get update;  \
  apt-get install --no-install-recommends -y supervisor=3.3.1-1.1; \
  gem install bundler -v 2.0.2 --no-document

# Copy gemfile first so cache can be reused
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY ./ ./

EXPOSE 3000

CMD [ "supervisord", "-c", "config/supervisor/supervisord.conf" ]
