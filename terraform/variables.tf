variable "gitlab_access_token" {
  sensitive = true
}

variable "github_access_token" {
  default = ""
}

variable "gitlab_hooks_auth_token" {
  default = ""
}

variable "gitlab_docker_registry_token" {
  default = ""
}

variable "redis_password" {
  default = ""
}

variable "ssl_cert_id" {
  default = ""
}

variable "sentry_dsn" {
  default = ""
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
