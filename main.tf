resource "docker_image" "launcher" {
  name = var.launcher_image
}

resource "docker_image" "portainer" {
  name = var.portainer_image
}

resource "docker_volume" "portainer_data" {
  name = var.portainer_volume_name
}

locals {
  launcher_html = templatefile("${path.module}/templates/launcher.html.tftpl", {
    games          = var.games
    portainer_port = var.portainer_port
  })
}

resource "docker_container" "launcher" {
  name  = var.launcher_name
  image = docker_image.launcher.image_id

  ports {
    internal = 80
    external = var.launcher_port
  }

  upload {
    file    = "/usr/share/nginx/html/index.html"
    content = local.launcher_html
  }

  restart = "unless-stopped"
}

module "games" {
  source = "./modules/game"

  for_each = var.games

  name          = each.key
  image         = each.value.image
  external_port = each.value.external_port
  internal_port = each.value.internal_port
}

resource "docker_container" "portainer" {
  name  = var.portainer_name
  image = docker_image.portainer.image_id

  ports {
    internal = 9000
    external = var.portainer_port
  }

  volumes {
    volume_name    = docker_volume.portainer_data.name
    container_path = "/data"
  }

  #Linux socket path to create the mount
  # this works fine on RD configured to use Dockerd (Moby)
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  restart = "unless-stopped"
}