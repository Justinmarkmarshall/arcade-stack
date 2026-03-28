resource "docker_image" "launcher" {
  name = var.launcher_image
}

resource "docker_image" "tetris" {
  name = var.tetris_image
}

resource "docker_image" "supermario" {
  name = var.supermario_image
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

  ports {
    internal = 80
    external = var.launcher_port
  }

  upload {
    file    = "/usr/share/nginx/html/index.html"
    content = <<-EOT
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
          <div class="card">
            <h2>Tetris</h2>
            <p>Classic block-stacking goodness.</p>
            <p><a href="http://localhost:${var.tetris_port}" target="_blank">Play Tetris</a></p>
          </div>
          <div class="card">
            <h2>Super Mario</h2>
            <p>Save Daisy the Princess!</p>
            <p><a href="http://localhost:${var.supermario_port}" target="_blank">Play Super Mario</a></p>
          </div>
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

  restart = "unless-stopped"
}

module "tetris" {
  source = "./modules/game"

  name          = var.tetris_name
  image         = var.tetris_image
  external_port          = var.tetris_port
  internal_port = 80
}

module "supermario" {
  source = "./modules/game"

  name          = var.supermario_name
  image         = var.supermario_image
  external_port          = var.supermario_port
  internal_port = 8080
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