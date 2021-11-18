terraform {
  backend "http" {}

  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6.0"
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
    repository = "https://dependabot-gitlab.gitlab.io/chart"
    version    = "0.2.0"
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
