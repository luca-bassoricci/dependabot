FROM registry.gitlab.com/gitlab-org/release-cli:v0.11.0 as release-cli
FROM ruby:2.7.6-slim-bullseye

ARG pip_version=21.3.1
ARG kubectl_version=v1.23.3
ARG helm_version=v3.8.0
ARG kubeval_version=v0.16.1
ARG helmdocs_version=1.7.0
ARG kind_version=v0.11.1
ARG bundler_version=2.3.10
ARG docker_version=5:20.10.14~3-0
ARG compose_plugin_version=2.3.3

ARG TARGETARCH=amd64

RUN set -eux; \
  apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  gnupg \
  git \
  build-essential \
  jq; \
  \
  gem install bundler -v ${bundler_version} --no-document; \
  \
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg; \
  \
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install kubectl
RUN set -eux; \
  curl --fail --location --output kubectl \
  "https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/${TARGETARCH}/kubectl"; \
  \
  chmod +x kubectl && mv kubectl /usr/local/bin/

# Install Helm
RUN set -eux;\
  curl --fail --location --output /tmp/helm.tar.gz \
  "https://get.helm.sh/helm-${helm_version}-linux-${TARGETARCH}.tar.gz"; \
  \
  mkdir -p "/usr/local/helm-${helm_version}"; \
  tar -xzf /tmp/helm.tar.gz -C "/usr/local/helm-${helm_version}"; \
  ln -s "/usr/local/helm-${helm_version}/linux-${TARGETARCH}/helm" /usr/local/bin/helm && \
  rm -f /tmp/helm.tar.gz; \
  \
  helm plugin install https://github.com/chartmuseum/helm-push.git; \
  helm plugin install https://github.com/databus23/helm-diff; \
  [ "$TARGETARCH" != "amd64" ] || helm plugin install https://github.com/mbenabda/helm-local-chart-version

# Install helmdocs
RUN set -eux; \
  HELM_ARCH=${TARGETARCH} && \
  if [ "${TARGETARCH}" = "amd64" ]; then HELM_ARCH="x86_64"; fi; \
  curl --fail --location --output /tmp/helmdocs.tar.gz \
  "https://github.com/norwoodj/helm-docs/releases/download/v${helmdocs_version}/helm-docs_${helmdocs_version}_Linux_${HELM_ARCH}.tar.gz"; \
  \
  tar -xzf /tmp/helmdocs.tar.gz helm-docs; \
  mv helm-docs /usr/local/bin/; \
  rm -rf /tmp/helmdocs.tar.gz helm-docs

# Install kubeval
RUN set -eux; \
  [ "$TARGETARCH" != "amd64" ] || \
  (curl --fail --location --output /tmp/kubeval.tar.gz \
  "https://github.com/instrumenta/kubeval/releases/download/${kubeval_version}/kubeval-linux-${TARGETARCH}.tar.gz" && \
  \
  tar -xzf /tmp/kubeval.tar.gz kubeval && \
  mv kubeval /usr/local/bin/ && \
  rm -rf tmp/kubeval.tar.gz kubeval)

# Install kind
RUN set -eux; \
  curl --fail --location --output kind https://kind.sigs.k8s.io/dl/${kind_version}/kind-linux-${TARGETARCH}; \
  chmod +x kind; \
  mv kind /usr/local/bin/

# Install gsutil
RUN set -eux; \
  curl --fail --location --output /tmp/gsutil.tar.gz "https://storage.googleapis.com/pub/gsutil.tar.gz"; \
  \
  tar -xzf /tmp/gsutil.tar.gz -C "/usr/local"; \
  ln -s "/usr/local/gsutil/gsutil" /usr/local/bin/gsutil && \
  rm -f /tmp/gsutil.tar.gz

# Install docker
RUN set -eux; \
  apt-get update && apt-get install --no-install-recommends -y \
  docker-ce=${docker_version}~debian-bullseye \
  docker-ce-cli=${docker_version}~debian-bullseye \
  docker-compose-plugin=${compose_plugin_version}~debian-bullseye

# Install release-cli
COPY --from=release-cli /usr/local/bin/release-cli /usr/local/bin/release-cli
