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

variable "tetris_name" {
  type    = string
  default = "arcade-tetris"
}

variable "tetris_port" {
  type    = number
  default = 3001
}

variable "tetris_image" {
  type    = string
  default = "bsord/tetris"
}

variable "supermario_name" {
  type    = string
  default = "arcade-supermario"
}

variable "supermario_port" {
  type    = number
  default = 3002
}

variable "supermario_image" {
  type    = string
  default = "pengbai/docker-supermario"
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

