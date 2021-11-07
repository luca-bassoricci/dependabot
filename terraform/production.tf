resource "google_compute_global_address" "default" {
  name = "dependabot-static-ip"
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = local.release.namespace
  }
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

resource "kubernetes_manifest" "frontend_config" {
  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata = {
      name      = "https-redirect"
      namespace = local.release.namespace
    }

    spec = {
      redirectToHttps = {
        enabled          = true
        responseCodeName = "PERMANENT_REDIRECT"
      }
    }
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

  timeout = 300

  values = [
    templatefile("values/common.tpl", {
      gitlab_access_token = var.gitlab_access_token
    }),
    yamlencode({
      service = {
        type = "ClusterIP"
        annotations = {
          "cloud.google.com/neg" = "{\"ingress\": true}"
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
        "dependabot-gitlab/dependency-test",
        "andrcuns/dependency-test-fork"
      ]
    }),
    yamlencode({
      credentials = {
        github_access_token = var.github_access_token
        gitlab_auth_token   = var.gitlab_hooks_auth_token
      }
      registriesCredentials = {
        GITLAB_DOCKER_REGISTRY_TOKEN = var.gitlab_docker_registry_token
      }
    }),
    yamlencode({
      env = {
        sentryDsn     = var.sentry_dsn
        redisUrl      = var.redis_url
        dependabotUrl = "https://${var.dependabot_host}"
        mongoDbUri    = "mongodb+srv://${var.mongodb_username}:${var.mongodb_password}@${var.mongodb_host}/${var.mongodb_db_name}?retryWrites=true&w=majority&authSource=admin"
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
      }
    }),
    yamlencode({
      web = {
        startupProbe = {
          initialDelaySeconds = 30
        }
      }
    }),
    yamlencode({
      redis = {
        enabled = false
        auth = {
          password = var.redis_password
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
    kubernetes_manifest.frontend_config
  ]
}
