resource "docker_image" "launcher" {
  name = var.launcher_image
}

resource "docker_image" "portainer" {
  name = var.portainer_image
}

resource "docker_image" "leaderboard_api" {
  name = var.leaderboard_api_image
}

resource "docker_image" "leaderboard_db" {
  name = var.leaderboard_db_image
}

resource "docker_volume" "portainer_data" {
  name = var.portainer_volume_name
}

resource "docker_volume" "leaderboard_db_data" {
  name = var.leaderboard_db_volume_name
}

resource "docker_network" "arcade_network" {
  name = var.arcade_network_name
}

locals {
  launcher_html = templatefile("${path.module}/templates/launcher.html.tftpl", {
    games          = var.games
    portainer_port = var.portainer_port
  })

  launcher_nginx_conf = templatefile("${path.module}/templates/launcher-nginx.conf.tftpl", {
    api_upstream = var.leaderboard_api_name
    api_port     = var.leaderboard_api_internal_port
  })

  healthcheck_defaults = {
    interval     = "30s"
    timeout      = "5s"
    retries      = 3
    start_period = "10s"
  }
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

  upload {
    file    = "/etc/nginx/conf.d/default.conf"
    content = local.launcher_nginx_conf
  }

  networks_advanced {
    name = docker_network.arcade_network.name
  }

  depends_on = [docker_container.leaderboard_api]

  healthcheck {
    test         = ["CMD-SHELL", "test -f /usr/share/nginx/html/index.html"]
    interval     = local.healthcheck_defaults.interval
    timeout      = local.healthcheck_defaults.timeout
    retries      = local.healthcheck_defaults.retries
    start_period = local.healthcheck_defaults.start_period
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
  network_name  = docker_network.arcade_network.name
}

resource "docker_container" "leaderboard_db" {
  name  = var.leaderboard_db_name
  image = docker_image.leaderboard_db.image_id

  env = [
    "POSTGRES_DB=${var.leaderboard_db_database}",
    "POSTGRES_USER=${var.leaderboard_db_username}",
    "POSTGRES_PASSWORD=${var.leaderboard_db_password}"
  ]

  ports {
    internal = 5432
    external = var.leaderboard_db_port
  }

  volumes {
    volume_name    = docker_volume.leaderboard_db_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.arcade_network.name
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U ${var.leaderboard_db_username} -d ${var.leaderboard_db_database}"]
    interval     = local.healthcheck_defaults.interval
    timeout      = local.healthcheck_defaults.timeout
    retries      = local.healthcheck_defaults.retries
    start_period = local.healthcheck_defaults.start_period
  }

  restart = "unless-stopped"
}

resource "docker_container" "leaderboard_api" {
  name  = var.leaderboard_api_name
  image = docker_image.leaderboard_api.image_id

  env = [
    "ASPNETCORE_ENVIRONMENT=Development",
    "ASPNETCORE_URLS=http://+:${var.leaderboard_api_internal_port}",
    "ConnectionStrings__LeaderboardDb=Host=${var.leaderboard_db_name};Port=5432;Database=${var.leaderboard_db_database};Username=${var.leaderboard_db_username};Password=${var.leaderboard_db_password}"
  ]

  ports {
    internal = var.leaderboard_api_internal_port
    external = var.leaderboard_api_port
  }

  networks_advanced {
    name = docker_network.arcade_network.name
  }

  depends_on = [docker_container.leaderboard_db]

  restart = "unless-stopped"
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

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  healthcheck {
    test         = ["CMD-SHELL", "test -S /var/run/docker.sock"]
    interval     = local.healthcheck_defaults.interval
    timeout      = local.healthcheck_defaults.timeout
    retries      = local.healthcheck_defaults.retries
    start_period = local.healthcheck_defaults.start_period
  }

  restart = "unless-stopped"
}



