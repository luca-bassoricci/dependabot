FROM andrcuns/ruby:2.6.6-buster-10.5

LABEL maintainer="andrejs.cunskis@gmail.com"

WORKDIR /sinatra

COPY --chown=1000:1000 Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=1000:1000 ./ ./

EXPOSE 4567

CMD [ "ruby", "gitlab_mock.rb", "-o", "0.0.0.0" ]
