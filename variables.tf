# class and type definitions

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
