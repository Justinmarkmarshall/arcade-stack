# 🕹️ Mini Arcade — Infrastructure as Fun

> Declarative retro gaming, powered by Terraform and Docker.

Spin up a fully containerised arcade cabinet with a single `terraform apply`.
Pulls and runs Tetris, plus a launcher page — all wired together as a mini internal platform.

---

## 🏗️ Stack

| Layer       | Technology              |
|-------------|-------------------------|
| Platform    | Docker                  |
| IaC         | Terraform               |
| Services    | Tetris, Nginx Launcher  |
| Networking  | Port mappings           |
| Storage     | Docker volumes          |

---

## 📦 Dependency Graph
```
docker_image.launcher        → docker_container.launcher
docker_image.game            → docker_container.game
docker_volume.arcade_data    → (used by future services)
```

---

## 🏗️ Modular Design

This Terraform configuration follows a modular structure for better maintainability and reusability:

- **`variables.tf`**: Defines all input variables with descriptions and default values, making the stack easily configurable.
- **`providers.tf`**: Configures the Docker provider with required settings.
- **`versions.tf`**: Specifies minimum Terraform version and provider requirements.
- **`main.tf`**: Contains the core resource definitions (Docker images, containers, volumes).
- **`outputs.tf`**: Exposes output values like URLs for easy access.
- **`terraform.tfvars`** (optional): Allows overriding default variable values.

This separation of concerns allows you to:
- Customize ports, images, and names via variables
- Easily extend with new services
- Maintain clean, readable code

---

## 🚀 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Docker](https://docs.docker.com/get-docker/) (with dockerd / moby runtime)

---

## ▶️ Usage
```bash
terraform init
terraform apply
```

That's it. Your arcade is live.

---

## 🌐 Services & Ports

| Service   | URL                          |
|-----------|------------------------------|
| Launcher  | http://localhost:8080        |
| Tetris    | http://localhost:3001        |

---

## 🔍 Drift Detection — The Cool Bit

Terraform's drift detection ensures your infrastructure stays in sync with your configuration.

Try this:
1. **Manually delete the Tetris container** (e.g., via Docker Desktop or Rancher Desktop UI)
2. Run `terraform plan` in this repo
3. Terraform will detect that Tetris is missing — that's **drift detection** in action
4. Run `terraform apply` and Terraform will recreate **only** the Tetris container

This is declarative infrastructure: you describe what should exist, and Terraform makes it so.

---

## 🧪 Manual Test Commands

<details>
<summary>Click to expand</summary>
```bash
# Tetris
docker run --rm -d -p 3001:80 --name tetris-test bsord/tetris

# Launcher (Nginx with custom HTML)
docker run -d -p 8080:80 --name launcher-test nginx:latest

# Force remove a container by ID
docker rm -f <container-id>
```

</details>