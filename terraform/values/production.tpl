service:
  port: ${service_port}
  annotations:
    service.beta.kubernetes.io/do-loadbalancer-name: "dependabot"
    service.beta.kubernetes.io/do-loadbalancer-certificate-id: "${ssl_cert_id}"
    service.beta.kubernetes.io/do-loadbalancer-healthcheck-protocol: "http"
    service.beta.kubernetes.io/do-loadbalancer-healthcheck-path: "/healthcheck"
    service.beta.kubernetes.io/do-loadbalancer-size-slug: "lb-small"

credentials:
  github_access_token: ${github_access_token}
  gitlab_auth_token: ${gitlab_hooks_auth_token}

registriesCredentials:
  GITLAB_DOCKER_REGISTRY_TOKEN: ${gitlab_docker_registry_token}

projects:
  - dependabot-gitlab/dependabot
  - dependabot-gitlab/dependency-test
  - andrcuns/dependency-test-fork

env:
  sentryDsn: ${sentry_dsn}
  dependabotUrl: ${dependabot_url}
  mongoDbUri: "mongodb+srv://${mongodb_username}:${mongodb_password}@${mongodb_host}/${mongodb_db_name}?retryWrites=true&w=majority&authSource=admin"

redis:
  auth:
    usePassword: true
    password: ${redis_password}

mongodb:
  enabled: false

worker:
  livenessProbe:
    timeoutSeconds: 6
    failureThreshold: 4
