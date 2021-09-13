image:
  repository: "registry.gitlab.com/dependabot-gitlab/dependabot"

credentials:
  gitlab_access_token: ${gitlab_access_token}

env:
  commandsPrefix: "@dependabot-bot"
  updateRetry: false
  metrics: false

service:
  type: LoadBalancer
