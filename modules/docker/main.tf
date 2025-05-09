terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

# Ejemplo: Creación de una imagen de Docker
resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = false
}

# Ejemplo: Creación de un contenedor usando la imagen
resource "docker_container" "nginx" {
  image    = docker_image.nginx.image_id
  name     = var.container_name
  hostname = var.container_name
  restart  = "unless-stopped"  # Reinicia automáticamente si se detiene

  ports {
    internal = 80
    external = var.external_port
    ip       = "0.0.0.0"  # Acepta conexiones desde cualquier interfaz
  }

  # Ejemplo de healthcheck (opcional)
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:80"]
    interval     = "30s"
    timeout      = "5s"
    start_period = "10s"
    retries      = 3
  }
}
