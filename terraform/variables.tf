# Application vars
variable "gitlab_access_token" {
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

variable "secret_key_base" {
  default = ""
}

variable "redis_password" {
  default = ""
}

variable "sentry_dsn" {
  default = ""
}

variable "dependabot_host" {
  default = ""
}

variable "mongodb_host" {
  default = "dependabot.ukhoq.mongodb.net"
}

variable "mongodb_username" {
  default = "dependabot"
}

variable "mongodb_password" {
  default = ""
}

variable "mongodb_db_name" {
  default = "dependabot"
}

variable "image_tag" {
  default = "master-latest"
}
