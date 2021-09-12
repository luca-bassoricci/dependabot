locals {
  values = {
    common_values = {
      image = {
        repository = "registry.gitlab.com/dependabot-gitlab/dependabot"
        tag        = var.image_tag
      }
      credentials = {
        gitlab_access_token = var.gitlab_access_token
      }
      env = {
        commandsPrefix = "@dependabot-bot"
        updateRetry    = false
        metrics        = false
      }
      service = {
        type = "LoadBalancer"
      }
    }
    development = {
      mongodb = {
        strategyType = "Recreate"
      }
    }
    production = {
      credentials = {
        github_access_token = var.github_access_token
        gitlab_auth_token   = var.gitlab_hooks_auth_token
      }
      registriesCredentials = {
        GITLAB_DOCKER_REGISTRY_TOKEN = var.gitlab_docker_registry_token
      }
      service = {
        port = 443
        annotations = {
          "service.beta.kubernetes.io/do-loadbalancer-certificate-id" = var.ssl_cert_id
        }
      }
      projects = [
        "dependabot-gitlab/dependabot",
        "dependabot-gitlab/dependency-test",
        "andrcuns/dependency-test-fork"
      ]
      env = {
        sentryDsn     = var.sentry_dsn
        dependabotUrl = var.dependabot_url
        mongoDbUri    = var.mongodb_uri
      }
      redis = {
        auth = {
          usePassword = true
          password    = var.redis_password
        }
      }
      mongodb = {
        enabled = false
      }
    }
  }
}
