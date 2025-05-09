# Ambiente de Desarrollo

Configuración de Terraform para gestionar contenedores Docker en el ambiente de desarrollo.

## Características específicas del ambiente de desarrollo

- Puerto expuesto: 8000
- Imagen: nginx:latest
- Nombre del contenedor: terraform-docker-dev

## Despliegue

```powershell
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Variables personalizables

Puedes personalizar el despliegue ajustando estas variables:

- `container_name`: Nombre del contenedor Docker
- `external_port`: Puerto externo para mapear al contenedor
- `image_name`: Imagen Docker a utilizar

Ejemplo:
```powershell
terraform apply -var="container_name=mi-app-dev" -var="external_port=8080"
```

## Integración con Jenkins

Este ambiente puede ser desplegado automáticamente usando el pipeline de Jenkins. 
Configura el parámetro ENVIRONMENT como "dev" al ejecutar el pipeline.
