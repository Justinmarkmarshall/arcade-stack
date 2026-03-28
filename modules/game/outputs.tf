output "container_name" {
  value = docker_container.this.name
}

output "image_name" {
  value = docker_image.this.name
}

output "url" {
  value = "http://localhost:${var.external_port}"
}