output "launcher_url" {
  value = "http://localhost:${var.launcher_port}"
}

output "portainer_url" {
  value = "http://localhost:${var.portainer_port}"
}

output "leaderboard_api_url" {
  value = "http://localhost:${var.leaderboard_api_port}"
}

output "leaderboard_postgres_port" {
  value = var.leaderboard_db_port
}
