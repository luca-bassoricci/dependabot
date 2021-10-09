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
    version    = "0.0.97"
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
