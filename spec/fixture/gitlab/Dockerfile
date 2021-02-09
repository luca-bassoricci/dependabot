ARG SINATRA_VERSION=2.1.0

FROM andrcuns/ruby:2.6.6-slim-10.8 as gitlab

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
