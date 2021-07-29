ARG SINATRA_VERSION=2.1.0

FROM registry.gitlab.com/dependabot-gitlab/dependabot/ruby:2.7.4-buster-latest as gitlab

LABEL maintainer="andrejs.cunskis@gmail.com"

FROM gitlab AS development

ARG SINATRA_VERSION

ENV RACK_ENV=test

RUN gem install --no-document \
  sinatra:${SINATRA_VERSION} \
  sinatra-contrib:${SINATRA_VERSION}

WORKDIR /sinatra

RUN gem install --no-document \
  sinatra:${SINATRA_VERSION} \
  sinatra-contrib:${SINATRA_VERSION}

FROM gitlab AS production

ARG SINATRA_VERSION

ENV RACK_ENV=production

RUN gem install --no-document \
  sinatra:${SINATRA_VERSION} \
  sinatra-contrib:${SINATRA_VERSION}

WORKDIR /sinatra

COPY ./ ./

EXPOSE 4567

CMD [ "ruby", "fake_gitlab.rb", "-o", "0.0.0.0" ]
