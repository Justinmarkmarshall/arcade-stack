
# here is the data
locals {
  # games is a map (object/dictionary)
  # so key -> value is tetris -> {name, image, external_port, internal_port}
  # I will use maps for the foreach loop, because Terraform requires stable keys
  games = {
    tetris = {
      name          = var.tetris_name
      image         = var.tetris_image
      external_port = var.tetris_port
      internal_port = 80
      title         = "Tetris"
      description   = "Classic block-stacking goodness."
    },
    supermario = {
      name          = var.supermario_name
      image         = var.supermario_image
      external_port = var.supermario_port
      internal_port = 8080
      title         = "Super Mario"
      description   = "Save Daisy the Princess!"
    }
  }

  # Dynamically generate HTML for games
  games_html = join("", [
    for game_key, game in local.games : <<-EOT
          <div class="card">
            <h2>${game.title}</h2>
            <p>${game.description}</p>
            <p><a href="http://localhost:${game.external_port}" target="_blank">Play ${game.title}</a></p>
          </div>
    EOT
  ])

  # Full HTML content for the launcher
  launcher_html = <<-EOT
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home Arcade</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            background: #111;
            color: #eee;
            text-align: center;
            padding: 40px;
          }
          h1 {
            margin-bottom: 30px;
          }
          .grid {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
          }
          .card {
            display: inline-block;
            background: #1e1e1e;
            border: 1px solid #333;
            border-radius: 12px;
            padding: 20px;
            width: 280px;
          }
          a {
            color: #7cc7ff;
            text-decoration: none;
            font-weight: bold;
          }
          a:hover {
            text-decoration: underline;
          }
        </style>
      </head>
      <body>
        <h1>🎮 Home Arcade</h1>
        <div class="grid">
${local.games_html}
          <div class="card">
            <h2>Portainer</h2>
            <p>Inspect containers, images, volumes and networks.</p>
            <p><a href="http://localhost:${var.portainer_port}" target="_blank">Open Portainer</a></p>
          </div>
        </div>
      </body>
      </html>
  EOT
}

# here is how the infra is defined using the data above

resource "docker_image" "launcher" {
  name = var.launcher_image
}

resource "docker_image" "portainer" {
  name = var.portainer_image
}

resource "docker_volume" "portainer_data" {
  name = var.portainer_volume_name
}

resource "docker_container" "launcher" {
  name  = var.launcher_name
  image = docker_image.launcher.image_id

  #containers are now linked together on a custom network, so they can talk to each other by container name
  networks_advanced {
    name = docker_network.arcade.name
  }

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

# custom docker network called arcade-network
resource "docker_network" "arcade" {
  name = "arcade-network"
}

module "games" {
  # now games are instantiated in a foreach loop, so we can easily add more games just by adding to the local.games map  
  for_each = local.games
  source   = "./modules/game"

  name          = each.value.name
  image         = each.value.image
  external_port = each.value.external_port
  internal_port = each.value.internal_port
  network_name = docker_network.arcade.name
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