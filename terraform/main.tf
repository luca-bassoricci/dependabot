terraform {
  backend "http" {}

  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.7.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3"
    }
  }
}

locals {
  namespace = "dependabot"
}

data "google_client_config" "default" {
}

data "google_container_cluster" "default" {
  name     = "dependabot"
  location = "us-central1-c"
}

provider "google" {
  project = "dependabot-gitlab"
  region  = "us-central1"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.default.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.default.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
  }
}

provider "helm" {
  alias = "development"
  kubernetes {}
}

resource "google_compute_global_address" "default" {
  name = "dependabot-static-ip"
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = local.namespace
  }
}

resource "kubernetes_manifest" "backend_config" {
  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "backendconfig"
      namespace = local.namespace
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
      namespace = local.namespace
    }

    spec = {
      domains = [var.dependabot_host]
    }
  }

  depends_on = [
    kubernetes_namespace.default
  ]
}

resource "kubernetes_manifest" "frontend_config" {
  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata = {
      name      = "https-redirect"
      namespace = local.namespace
    }

    spec = {
      redirectToHttps = {
        enabled          = true
        responseCodeName = "PERMANENT_REDIRECT"
      }
    }
  }

  depends_on = [
    kubernetes_namespace.default
  ]
}


resource "helm_release" "dependabot" {
  name       = "dependabot-gitlab"
  chart      = "dependabot-gitlab"
  repository = "https://dependabot-gitlab.gitlab.io/chart"
  version    = "0.2.2"

  lint              = true
  atomic            = true
  wait              = true
  dependency_update = true
  create_namespace  = false

  namespace = local.namespace

  timeout = 300

  values = [
    yamlencode({
      image = {
        repository = "registry.gitlab.com/dependabot-gitlab/dependabot"
      }
    }),
    yamlencode({
      service = {
        type = "ClusterIP"
        annotations = {
          "cloud.google.com/neg"            = "{\"ingress\": true}"
          "cloud.google.com/backend-config" = "{\"default\": \"${kubernetes_manifest.backend_config.manifest.metadata.name}\"}"
        }
      }
    }),
    yamlencode({
      ingress = {
        enabled = true
        annotations = {
          "kubernetes.io/ingress.class"                 = "gce"
          "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.default.name
          "networking.gke.io/managed-certificates"      = kubernetes_manifest.managed_certs.manifest.metadata.name
          "networking.gke.io/v1beta1.FrontendConfig"    = kubernetes_manifest.frontend_config.manifest.metadata.name
        }
        hosts = [
          {
            host  = var.dependabot_host
            paths = ["/", "/api/*", "/sidekiq/*", "/jobs/*"]
          }
        ]
      }
    }),
    yamlencode({
      projects = [
        "dependabot-gitlab/dependabot",
        "dependabot-gitlab/chart",
        "dependabot-gitlab/dependency-test",
        "andrcuns/dependency-test-fork"
      ]
    }),
    yamlencode({
      credentials = {
        gitlab_access_token = var.gitlab_access_token
        github_access_token = var.github_access_token
        gitlab_auth_token   = var.gitlab_hooks_auth_token
      }
      registriesCredentials = {
        GITLAB_DOCKER_REGISTRY_TOKEN = var.gitlab_docker_registry_token
      }
    }),
    yamlencode({
      env = {
        secretKeyBase  = var.secret_key_base
        sentryDsn      = var.sentry_dsn
        dependabotUrl  = "https://${var.dependabot_host}"
        mongoDbUri     = "mongodb+srv://${var.mongodb_username}:${var.mongodb_password}@${var.mongodb_host}/${var.mongodb_db_name}?retryWrites=true&w=majority&authSource=admin"
        commandsPrefix = "@dependabot-bot"
        updateRetry    = false
      }
    }),
    yamlencode({
      worker = {
        updateStrategy = {
          type = "Recreate"
        }
        startupProbe = {
          initialDelaySeconds = 30
        }
        resources = {
          requests = {
            cpu    = "700m"
            memory = "700Mi"
          }
        }
      }
    }),
    yamlencode({
      web = {
        startupProbe = {
          initialDelaySeconds = 30
        }
        resources = {
          requests = {
            cpu    = "100m"
            memory = "300Mi"
          }
        }
      }
    }),
    yamlencode({
      redis = {
        enabled = true
        auth = {
          usePassword = true
          password    = var.redis_password
        }
        master = {
          resources = {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
          }
        }
      }
      mongodb = {
        enabled = false
      }
    })
  ]

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  depends_on = [
    google_compute_global_address.default,
    kubernetes_manifest.managed_certs,
    kubernetes_manifest.backend_config,
    kubernetes_manifest.frontend_config,
  ]
}
