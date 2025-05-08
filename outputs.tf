output "container_id" {
  description = "ID del contenedor Docker creado"
  value       = docker_container.nginx.id
}

output "container_network_data" {
  description = "Datos de red del contenedor"
  value       = docker_container.nginx.network_data
}

output "container_name" {
  description = "Nombre del contenedor"
  value       = docker_container.nginx.name
}

output "container_ports" {
  description = "Mapeo de puertos del contenedor"
  value       = docker_container.nginx.ports
}

output "container_access_url" {
  description = "URL para acceder al contenedor"
  value       = "http://localhost:${var.external_port}"
}

output "image_id" {
  description = "ID de la imagen Docker"
  value       = docker_image.nginx.image_id
}
