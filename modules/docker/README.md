# Módulo Docker para Terraform

Este módulo permite gestionar contenedores Docker utilizando Terraform.

## Características

- Creación y gestión de contenedores Docker
- Configuración de puertos y redes
- Políticas de reinicio y health checks
- Gestión de imágenes Docker

## Uso

```hcl
module "docker" {
  source = "../modules/docker"
  
  container_name = "mi-contenedor"
  external_port  = 8080
  image_name     = "nginx:latest"
}
```

## Variables de entrada

| Nombre | Descripción | Tipo | Valor por defecto |
|--------|-------------|------|-------------------|
| container_name | Nombre del contenedor Docker | string | "terraform-nginx" |
| external_port | Puerto externo para mapear | number | 8080 |
| image_name | Imagen Docker a utilizar | string | "nginx:latest" |

## Outputs

| Nombre | Descripción |
|--------|-------------|
| container_access_url | URL para acceder al contenedor |
| container_network_data | Datos de red del contenedor |
