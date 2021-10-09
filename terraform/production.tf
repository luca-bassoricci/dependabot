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
        dependabotUrl = "https://${var.dependabot_host}"
        mongoDbUri : "mongodb+srv://${var.mongodb_username}:${var.mongodb_password}@${var.mongodb_host}/${var.mongodb_db_name}?retryWrites=true&w=majority&authSource=admin"
      }
      migrationJob = {
        activeDeadlineSeconds = 300
      }
    }),
    yamlencode({
      worker = {
        updateStrategy = { type = "Recreate" }
        startupProbe   = { initialDelaySeconds = 30 }
        resources = {
          requests = {
            memory = "1Gi"
            cpu    = 1
          }
        }
      }
    }),
    yamlencode({
      web = {
        startupProbe = { initialDelaySeconds = 30 }
        resources = {
          requests = {
            memory = "256Mi"
            cpu    = "250m"
          }
        }
      }
    }),
    yamlencode({
      redis = {
        master = {
          resources = {
            requests = {
              memory = "256Mi"
              cpu    = "250m"
            }
          }
        }
        auth = {
          usePassword = true
          password    = var.redis_password
        }
      }
      mongodb = { enabled = false }
    }),
  ]

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  depends_on = [
    google_container_cluster.default,
    google_compute_global_address.default,
    kubernetes_manifest.managed_certs
  ]
}
