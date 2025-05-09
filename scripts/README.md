# Scripts de Automatización

Esta carpeta contiene scripts de automatización para facilitar la gestión de la infraestructura con Terraform y Jenkins.

## Scripts disponibles

- **deploy.ps1**: Script para despliegue local de la infraestructura
- **jenkins-terraform.ps1**: Script para integración con Jenkins

## Uso de jenkins-terraform.ps1

Este script permite ejecutar acciones de Terraform desde Jenkins en entornos Windows:

```powershell
.\jenkins-terraform.ps1 -Action apply -ContainerName webapp -ExternalPort 8080 -ImageName nginx:alpine -Environment dev
```

### Parámetros

- **Action**: Acción de Terraform a ejecutar (plan, apply, destroy)
- **ContainerName**: Nombre del contenedor Docker
- **ExternalPort**: Puerto externo para mapear al contenedor
- **ImageName**: Nombre de la imagen Docker a utilizar
- **Environment**: Entorno a desplegar (dev, prod)

## Uso de deploy.ps1

Script para despliegue local más simplificado:

```powershell
.\deploy.ps1 -Environment dev -Action apply
```

### Parámetros

- **Environment**: Entorno a desplegar (dev, prod)
- **Action**: Acción de Terraform a ejecutar (plan, apply, destroy)
