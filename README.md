# Mini Arcade - Infrastructure as Fun

> Declarative retro gaming, powered by Terraform and Docker.

Spin up a containerised arcade cabinet with a single `terraform apply`.
The stack now includes game containers, a launcher UI, the leaderboard API, and PostgreSQL for score storage.

## Services

- Launcher UI: `http://localhost:8080`
- Leaderboard API: `http://localhost:8081`
- PostgreSQL: `localhost:5433`
- Portainer: `http://localhost:9000`

## What Gets Deployed

- Existing arcade game containers from the `games` map
- An Nginx launcher page that now includes a high score form and leaderboard table
- The GHCR-hosted leaderboard API image: `ghcr.io/justinmarkmarshall/arcade-leaderboard:latest`
- A PostgreSQL 16 container with a persistent Docker volume

## Usage

```bash
terraform init
terraform apply
```

Then open `http://localhost:8080`.
Use the launcher page to play games, submit scores, and view the top 10 scores per game.

## Persistent Leaderboard Storage

The leaderboard PostgreSQL data is stored in a Docker volume managed by Terraform.
That volume will be destroyed along with the rest of the stack when you run `terraform destroy`.
