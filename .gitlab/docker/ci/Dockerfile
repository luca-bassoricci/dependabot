FROM registry.gitlab.com/gitlab-org/release-cli:v0.11.0 as release-cli
FROM docker:20.10.12

ARG pip_version=21.3.1
ARG kubectl_version=v1.23.3
ARG helm_version=v3.8.0
ARG kubeval_version=v0.16.1
ARG helmdocs_version=1.7.0
ARG kind_version=v0.11.1
ARG compose_version=1.29.2

RUN apk --no-cache add \
  bash \
  curl \
  git \
  grep \
  jq \
  libc6-compat \
  openssh-client \
  py3-pip \
  py3-wheel \
  python3 && \
  pip install --upgrade pip==${pip_version}

# Install kubectl
RUN set -eux; \
  curl --fail --location --output kubectl \
  "https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/amd64/kubectl"; \
  \
  chmod +x kubectl && mv kubectl /usr/local/bin/

# Install Helm
RUN set -eux;\
  curl --fail --location --output /tmp/helm.tar.gz \
  "https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz"; \
  \
  mkdir -p "/usr/local/helm-${helm_version}"; \
  tar -xzf /tmp/helm.tar.gz -C "/usr/local/helm-${helm_version}"; \
  ln -s "/usr/local/helm-${helm_version}/linux-amd64/helm" /usr/local/bin/helm && \
  rm -f /tmp/helm.tar.gz; \
  \
  helm plugin install https://github.com/chartmuseum/helm-push.git; \
  helm plugin install https://github.com/mbenabda/helm-local-chart-version; \
  helm plugin install https://github.com/databus23/helm-diff

# Install helmdocs
RUN set -eux; \
  curl --fail --location --output /tmp/helmdocs.tar.gz \
  "https://github.com/norwoodj/helm-docs/releases/download/v${helmdocs_version}/helm-docs_${helmdocs_version}_Linux_x86_64.tar.gz"; \
  \
  tar -xzf /tmp/helmdocs.tar.gz helm-docs; \
  mv helm-docs /usr/local/bin/; \
  rm -rf /tmp/helmdocs.tar.gz helm-docs

# Install kubeval
RUN set -eux; \
  curl --fail --location --output /tmp/kubeval.tar.gz \
  "https://github.com/instrumenta/kubeval/releases/download/${kubeval_version}/kubeval-linux-amd64.tar.gz"; \
  \
  tar -xzf /tmp/kubeval.tar.gz kubeval; \
  mv kubeval /usr/local/bin/; \
  rm -rf tmp/kubeval.tar.gz kubeval

# Install kind
RUN set -eux; \
  curl --fail --location --output kind https://kind.sigs.k8s.io/dl/${kind_version}/kind-linux-amd64; \
  chmod +x kind; \
  mv kind /usr/local/bin/

# Install gsutil
RUN set -eux; \
  curl --fail --location --output /tmp/gsutil.tar.gz "https://storage.googleapis.com/pub/gsutil.tar.gz"; \
  \
  tar -xzf /tmp/gsutil.tar.gz -C "/usr/local"; \
  ln -s "/usr/local/gsutil/gsutil" /usr/local/bin/gsutil && \
  rm -f /tmp/gsutil.tar.gz

# Install docker-compose
RUN set -eux; \
  apk add --no-cache --virtual .docker-compose-deps \
  python3-dev \
  libffi-dev \
  openssl-dev \
  gcc \
  libc-dev \
  make; \
  \
  pip install "docker-compose==${compose_version}"; \
  apk del .docker-compose-deps

# Install release-cli
COPY --from=release-cli /usr/local/bin/release-cli /usr/local/bin/release-cli
