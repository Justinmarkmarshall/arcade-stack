# modules/game/variables.tf
# template for all variables
variable "name" {
  description = "Container name"
  type        = string
}

variable "image" {
  description = "Docker image"
  type        = string
}

variable "external_port" {
  description = "Host port"
  type        = number
}

variable "internal_port" {
  description = "Container port"
  type        = number
}

variable "restart_policy" {
  description = "Restart policy for the container"
  type        = string
  default     = "unless-stopped"
}