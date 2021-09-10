terraform {
  backend "http" {}

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

provider "helm" {
}

resource "helm_release" "dependabot" {
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
    yamlencode(local.values.common_values),
    yamlencode(local.values[var.environment])
  ]
}
