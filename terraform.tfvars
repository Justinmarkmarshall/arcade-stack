launcher_name  = "arcade-launcher"
launcher_port  = 8080
launcher_image = "nginx:latest"

portainer_name        = "arcade-portainer"
portainer_port        = 9000
portainer_image       = "portainer/portainer-ce:latest"
portainer_volume_name = "portainer-data"

games = {
  tetris = {
    name          = "tetris"
    image         = "bsord/tetris:latest"
    external_port = 3001
    internal_port = 80
    title         = "Tetris"
    description   = "Classic block-stacking goodness."
  }

  supermario = {
    name          = "supermario"
    image         = "pengbai/docker-supermario:latest"
    external_port = 3002
    internal_port = 8080
    title         = "Super Mario"
    description   = "Save Daisy the Princess!"
  }
}