variable "arcade_network_name" {
  type    = string
  default = "arcade-network"
}

variable "launcher_name" {
  type    = string
  default = "arcade-launcher"
}

variable "launcher_port" {
  type    = number
  default = 8080
}

variable "launcher_image" {
  type    = string
  default = "nginx:latest"
}

variable "portainer_name" {
  type    = string
  default = "arcade-portainer"
}

variable "portainer_port" {
  type    = number
  default = 9000
}

variable "portainer_image" {
  type    = string
  default = "portainer/portainer-ce:latest"
}

variable "portainer_volume_name" {
  type    = string
  default = "portainer_data"
}

variable "leaderboard_api_name" {
  type    = string
  default = "arcade-leaderboard-api"
}

variable "leaderboard_api_image" {
  type    = string
  default = "ghcr.io/justinmarkmarshall/arcade-leaderboard:latest"
}

variable "leaderboard_api_port" {
  type    = number
  default = 8081
}

variable "leaderboard_api_internal_port" {
  type    = number
  default = 8080
}

variable "leaderboard_db_name" {
  type    = string
  default = "arcade-leaderboard-db"
}

variable "leaderboard_db_image" {
  type    = string
  default = "postgres:16"
}

variable "leaderboard_db_port" {
  type    = number
  default = 5433
}

variable "leaderboard_db_database" {
  type    = string
  default = "arcade_leaderboard"
}

variable "leaderboard_db_username" {
  type    = string
  default = "postgres"
}

variable "leaderboard_db_password" {
  type      = string
  default   = "postgres"
  sensitive = true
}

variable "leaderboard_db_volume_name" {
  type        = string
  default     = "arcade-leaderboard-data"
  description = "Docker volume used to persist leaderboard PostgreSQL data. Protected from destroy so scores survive redeployments."
}

variable "games" {
  description = "Game container definitions"
  type = map(object({
    image         = string
    external_port = number
    internal_port = number
    title         = string
    description   = string
  }))
}


