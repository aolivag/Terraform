variable "docker_host" {
  type        = string
  description = "La URL de conexión al host Docker"
  default     = "npipe:////.//pipe//docker_engine" # Valor predeterminado para Windows
}

variable "container_name" {
  type        = string
  description = "Nombre para el contenedor Docker"
  default     = "terraform-docker-demo"
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
