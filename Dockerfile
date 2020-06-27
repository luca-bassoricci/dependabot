FROM dependabot/dependabot-core:0.118.5

ENV BUNDLE_PATH=vendor/bundle \
  BUNDLE_WITHOUT="development:test"

WORKDIR /dependabot

RUN gem install bundler -v 2.0.2 --no-document

# Copy gemfile first so cache can be reused
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY ./ ./

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "sidekiq" ]

