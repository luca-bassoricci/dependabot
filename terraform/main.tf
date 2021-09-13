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

locals {
  development = var.environment == "development"
  release = {
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
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "helm" {
  kubernetes {
    host  = data.digitalocean_kubernetes_cluster.dependabot.endpoint
    token = data.digitalocean_kubernetes_cluster.dependabot.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.dependabot.kube_config[0].cluster_ca_certificate
    )
  }
}

provider "helm" {
  alias = "development"
  kubernetes {}
}

data "digitalocean_kubernetes_cluster" "dependabot" {
  name = "dependabot"
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

resource "helm_release" "dependabot-development" {
  count = local.development ? 1 : 0

  provider = helm.development

  name       = local.release.name
  repository = local.release.repository
  chart      = local.release.chart
  version    = local.release.version

  lint              = local.release.lint
  atomic            = local.release.atomic
  wait              = local.release.wait
  create_namespace  = local.release.create_namespace
  dependency_update = local.release.dependency_update

  namespace = local.release.namespace

  values = [
    templatefile("values/common.tpl", {
      gitlab_access_token = var.gitlab_access_token
    }),
    file("values/development.tpl")
  ]

  set {
    name  = "image.tag"
    value = var.image_tag
  }
}

resource "helm_release" "dependabot" {
  count = local.development ? 0 : 1

  name       = local.release.name
  repository = local.release.repository
  chart      = local.release.chart
  version    = local.release.version

  lint              = local.release.lint
  atomic            = local.release.atomic
  wait              = local.release.wait
  create_namespace  = local.release.create_namespace
  dependency_update = local.release.dependency_update

  namespace = local.release.namespace

  values = [
    templatefile("values/common.tpl", {
      gitlab_access_token = var.gitlab_access_token
    }),
    templatefile("values/production.tpl", {
      service_port                 = 443
      github_access_token          = var.github_access_token,
      gitlab_hooks_auth_token      = var.gitlab_hooks_auth_token,
      gitlab_docker_registry_token = var.gitlab_docker_registry_token,
      sentry_dsn                   = var.sentry_dsn,
      dependabot_url               = var.dependabot_url,
      mongodb_host                 = var.mongodb_host
      mongodb_db_name              = var.mongodb_db_name
      mongodb_username             = var.mongodb_username,
      mongodb_password             = var.mongodb_password,
      redis_password               = var.redis_password,
      ssl_cert_id                  = local.development ? 0 : digitalocean_certificate.default[0].uuid
    })
  ]

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  depends_on = [
    digitalocean_certificate.default
  ]
}
