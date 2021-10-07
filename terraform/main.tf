terraform {
  backend "http" {}

  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 3.87"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3"
    }
  }
}

locals {
  development = var.environment == "development"
  release = {
    name       = "dependabot-gitlab"
    repository = "https://andrcuns.github.io/charts"
    version    = "0.0.94"
    chart      = var.chart

    lint              = true
    atomic            = true
    wait              = true
    create_namespace  = true
    dependency_update = true

    namespace = "dependabot"
  }
}

data "google_client_config" "default" {
}

provider "google" {
  project = "dependabot-gitlab"
  region  = "us-central1"
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.default.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)

  experiments {
    manifest_resource = true
  }
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.default.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
  }
}

provider "helm" {
  alias = "development"
  kubernetes {}
}

resource "google_container_cluster" "default" {
  name        = "dependabot"
  description = "Cluster for hosting influxDb and Grafana instance for metrics gathering"
  location    = "us-central1"

  enable_autopilot = true

  vertical_pod_autoscaling {
    enabled = true
  }
}

resource "google_compute_global_address" "default" {
  name = "dependabot-static-ip"
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = local.release.namespace
  }
}

resource "kubernetes_manifest" "backend_config" {
  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "backendconfig"
      namespace = local.release.namespace
    }

    spec = {
      healthCheck = {
        port        = 3000
        type        = "HTTP"
        requestPath = "/healthcheck"
      }
    }
  }

  depends_on = [
    kubernetes_namespace.default
  ]
}

resource "kubernetes_manifest" "managed_certs" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"
    metadata = {
      name      = "managed-cert"
      namespace = local.release.namespace
    }

    spec = {
      domains = [var.dependabot_host]
    }
  }
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

  timeout = 600

  values = [
    templatefile("values/common.tpl", {
      gitlab_access_token = var.gitlab_access_token
    }),
    templatefile("values/production.tpl", {
      github_access_token          = var.github_access_token,
      gitlab_hooks_auth_token      = var.gitlab_hooks_auth_token,
      gitlab_docker_registry_token = var.gitlab_docker_registry_token,
      sentry_dsn                   = var.sentry_dsn,
      dependabot_host              = var.dependabot_host,
      mongodb_host                 = var.mongodb_host
      mongodb_db_name              = var.mongodb_db_name
      mongodb_username             = var.mongodb_username,
      mongodb_password             = var.mongodb_password,
      redis_password               = var.redis_password,
      static_ip                    = google_compute_global_address.default.name,
      backend_config               = kubernetes_manifest.backend_config.manifest.metadata.name
      managed_certs                = kubernetes_manifest.managed_certs.manifest.metadata.name
    })
  ]

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  depends_on = [
    google_container_cluster.default,
    google_compute_global_address.default,
    kubernetes_manifest.backend_config,
    kubernetes_manifest.managed_certs
  ]
}
