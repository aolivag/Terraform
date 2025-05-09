# Ambiente de Producción

Configuración de Terraform para gestionar contenedores Docker en el ambiente de producción.

## Características específicas del ambiente de producción

- Puerto expuesto: 80 (puerto web estándar)
- Imagen: nginx:stable (versión estable)
- Nombre del contenedor: terraform-docker-prod

## Despliegue

```powershell
cd environments/prod
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
terraform apply -var="container_name=mi-app-prod" -var="external_port=80"
```

## Integración con Jenkins

Este ambiente puede ser desplegado automáticamente usando el pipeline de Jenkins:
```powershell
.\scripts\jenkins-terraform.ps1 -Action apply -Environment prod
```

## Consideraciones para producción

- El estado de Terraform se almacena localmente por defecto. Para un entorno de producción, considera configurar un backend remoto.
- Revisa la configuración de seguridad antes de exponer puertos en producción.
- Considera usar variables para secretos y valores sensibles.
