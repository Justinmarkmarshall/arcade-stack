
# modules/game/main.tf
# functions like a template for all game containers
# variable "name" {}
# variable "image" {}
# variable "port" {}
# variable "internal_port" {}

resource "docker_image" "this" {
  name = var.image
}

resource "docker_container" "this" {
  name  = var.name
  image = docker_image.this.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  restart = "unless-stopped"
}