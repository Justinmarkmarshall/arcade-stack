# modules/game/variables.tf
# only knows about a single game
variable "name" {
  description = "Container name"
  type        = string
}

variable "image" {
  description = "Docker image"
  type        = string
}

variable "restart_policy" {
  description = "Restart policy for the container"
  type        = string
  default     = "unless-stopped"
}

variable "network_name" {
  description = "Docker network to connect to"
  type        = string
  default     = "arcade-network"
}