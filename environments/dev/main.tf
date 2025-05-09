module "docker" {
  source = "../../modules/docker"
  
  container_name = var.container_name
  external_port  = var.external_port
  image_name     = var.image_name
}

# Variables para el entorno dev
variable "container_name" {
  type        = string
  description = "Nombre para el contenedor Docker"
  default     = "terraform-docker-dev"
}

variable "external_port" {
  type        = number
  description = "Puerto externo para mapear al contenedor"
  default     = 8000
}

variable "image_name" {
  type        = string
  description = "Nombre de la imagen Docker a utilizar"
  default     = "nginx:latest"
}

# Outputs
output "container_access_url" {
  description = "URL para acceder al contenedor en entorno de desarrollo"
  value       = module.docker.container_access_url
}
