FROM debian:11.1-slim as buster
FROM buster as ruby-install

ARG RUBY_MINOR_VERSION=2.7
ARG RUBY_VERSION=2.7.4
ARG RUBY_BUILD_VERSION=20210720
ARG RUBYGEMS_VERSION=3.2.24
ARG BUNDLER_VERSION=2.2.24

ARG DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      build-essential \
      libffi-dev \
      zlib1g-dev \
      curl \
      ca-certificates \
      libssl-dev \
      libreadline-dev; \
    rm -rf /var/lib/apt/lists/*

# Set environment
ENV PATH=/usr/local/ruby/bin:$PATH

#Install ruby
RUN set -eux; \
    export RUBY_INSTALL_PATH=/usr/local/ruby; \
    \
    # Install ruby-build tool
    curl -L https://github.com/rbenv/ruby-build/archive/v${RUBY_BUILD_VERSION}.tar.gz -o ruby-build.tar.gz && \
      tar -xzf ruby-build.tar.gz && \
      ./ruby-build-${RUBY_BUILD_VERSION}/install.sh && \
      rm -r ruby-build.tar.gz ruby-build-${RUBY_BUILD_VERSION}; \
    \
    # Install ruby
    TMPDIR=/tmp CONFIGURE_OPTS="--disable-install-doc" \
      ruby-build ${RUBY_VERSION} ${RUBY_INSTALL_PATH}; \
    \
    # Don't install documents
    mkdir ${RUBY_INSTALL_PATH}/etc && \
      echo "install: --no-document" >> ${RUBY_INSTALL_PATH}/etc/gemrc && \
      echo "update: --no-document" >> ${RUBY_INSTALL_PATH}/etc/gemrc; \
    \
    # Update rubygems version
    gem update --system ${RUBYGEMS_VERSION} && \
      gem uninstall rubygems-update --executables; \
    # Install bundler
    gem install --no-document --force bundler -v ${BUNDLER_VERSION}; \
    \
    # Clean
    rm -rf \
      /tmp/* \
      /usr/local/bin/* \
      /usr/local/share/ruby-build \
      /root/.gem \
      /usr/local/ruby/lib/ruby/gems/${RUBY_MINOR_VERSION}.0/cache/*;

FROM buster

ARG DEBIAN_FRONTEND=noninteractive

# Set environment
ENV PATH=/usr/local/ruby/bin:$PATH

# Silence bundler root warning
ENV BUNDLE_SILENCE_ROOT_WARNING=1

# Install some essential system libs
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      build-essential \
      curl \
      git \
      zlib1g-dev \
      ca-certificates \
      gnupg2 \
      libreadline-dev \
      openssh-client; \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY --from=ruby-install /usr/local/ruby /usr/local/ruby
