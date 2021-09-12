# Global vars
variable "kubernetes_config" {
  default = "~/.kube/config"
}

variable "do_token" {
  sensitive = true
}

# Application vars
variable "gitlab_access_token" {
  sensitive = true
}

variable "github_access_token" {
  default   = ""
  sensitive = true
}

variable "gitlab_hooks_auth_token" {
  default   = ""
  sensitive = true
}

variable "gitlab_docker_registry_token" {
  default   = ""
  sensitive = true
}

variable "redis_password" {
  default   = ""
  sensitive = true
}

variable "sentry_dsn" {
  default   = ""
  sensitive = true
}

variable "dependabot_url" {
  default = ""
}

variable "mongodb_uri" {
  default   = ""
  sensitive = true
}

variable "image_tag" {
  default = "master-latest"
}

variable "environment" {
  default = "development"
}
