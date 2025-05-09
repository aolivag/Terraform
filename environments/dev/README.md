# Ambiente de Desarrollo

Configuración de Terraform para gestionar contenedores Docker en el ambiente de desarrollo.

## Características específicas del ambiente de desarrollo

- Puerto expuesto: 8000
- Imagen: nginx:latest
- Nombre del contenedor: terraform-docker-dev

## Despliegue

```bash
cd environments/dev
terraform init
terraform apply
```
