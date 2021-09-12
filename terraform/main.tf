terraform {
  backend "http" {}

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubernetes_config
  }
}

locals {
  development = var.environment == "development"
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_domain" "default" {
  count = local.development ? 0 : 1

  name = "dependabot-gitlab.co"
}

resource "digitalocean_certificate" "default" {
  count = local.development ? 0 : 1

  name = "dependabot-gitlab"
  type = "lets_encrypt"

  domains = [
    digitalocean_domain.default[count.index].name
  ]

  depends_on = [
    digitalocean_domain.default
  ]
}

resource "digitalocean_record" "www" {
  count = local.development ? 0 : 1

  domain = digitalocean_domain.default[count.index].name
  type   = "CNAME"
  name   = "www"
  value  = "@"

  depends_on = [
    digitalocean_domain.default
  ]
}

resource "helm_release" "dependabot" {
  count = local.development ? 0 : 1

  name       = "dependabot-gitlab"
  repository = "https://andrcuns.github.io/charts"
  chart      = "dependabot-gitlab"
  version    = "0.0.85"

  lint              = true
  atomic            = true
  wait              = true
  create_namespace  = true
  dependency_update = true

  namespace = "dependabot"

  values = [
    templatefile("values/common.tpl", {
      image_tag           = var.image_tag,
      gitlab_access_token = var.gitlab_access_token,
    }),
    templatefile("values/${var.environment}.tpl", {
      service_port                 = 443
      github_access_token          = var.github_access_token,
      gitlab_hooks_auth_token      = var.gitlab_hooks_auth_token,
      gitlab_docker_registry_token = var.gitlab_docker_registry_token,
      sentry_dsn                   = var.sentry_dsn,
      dependabot_url               = var.dependabot_url,
      mongodb_uri                  = var.mongodb_uri,
      redis_password               = var.redis_password,
      ssl_cert_id                  = digitalocean_certificate.default[count.index].uuid
    })
  ]

  depends_on = [
    digitalocean_certificate.default
  ]
}
