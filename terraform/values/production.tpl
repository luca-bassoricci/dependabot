service:
  type: ClusterIP
  annotations:
    cloud.google.com/neg: '{"ingress": true}'
    cloud.google.com/backend-config: '{"default": "${backend_config}"}'

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: gce
    kubernetes.io/ingress.global-static-ip-name: ${static_ip}
    networking.gke.io/managed-certificates: ${managed_certs}
  hosts:
    - host: ${dependabot_host}
      paths:
        - /
        - /api/*
        - /sidekiq/*
        - /jobs/*

projects:
  - dependabot-gitlab/dependabot
  - dependabot-gitlab/dependency-test
  - andrcuns/dependency-test-fork

credentials:
  github_access_token: ${github_access_token}
  gitlab_auth_token: ${gitlab_hooks_auth_token}

registriesCredentials:
  GITLAB_DOCKER_REGISTRY_TOKEN: ${gitlab_docker_registry_token}

env:
  sentryDsn: ${sentry_dsn}
  dependabotUrl: https://${dependabot_host}
  mongoDbUri: "mongodb+srv://${mongodb_username}:${mongodb_password}@${mongodb_host}/${mongodb_db_name}?retryWrites=true&w=majority&authSource=admin"

migrationJob:
  activeDeadlineSeconds: 300

worker:
  updateStrategy:
    type: Recreate
  livenessProbe:
    failureThreshold: 10
    periodSeconds: 10
  resources:
    requests:
      memory: "1Gi"
      cpu: "700m"
    limits:
      memory: "1Gi"
      cpu: "700m"

web:
  resources:
    requests:
      memory: "512Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "250m"

redis:
  master:
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "256Mi"
        cpu: "250m"

  auth:
    usePassword: true
    password: ${redis_password}

mongodb:
  enabled: false
