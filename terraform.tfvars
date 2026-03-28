launcher_name  = "arcade-launcher"
launcher_port  = 8080
launcher_image = "nginx:latest"

tetris_name  = "arcade-tetris"
tetris_port  = 3001
tetris_image = "bsord/tetris"

supermario_name  = "arcade-supermario"
supermario_port  = 3002
supermario_image = "pengbai/docker-supermario"

portainer_name        = "arcade-portainer"
portainer_port        = 9000
portainer_image       = "portainer/portainer-ce:latest"
portainer_volume_name = "portainer-data"