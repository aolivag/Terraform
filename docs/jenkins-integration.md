# Integración con Jenkins

Esta guía proporciona detalles sobre cómo integrar este proyecto Terraform con Jenkins para automatizar despliegues de infraestructura.

## Archivos de configuración

- `ci/Jenkinsfile`: Pipeline estándar para Jenkins, adaptado para Windows
- `ci/Jenkinsfile.docker`: Pipeline que utiliza Docker como agente
- `ci/Jenkinsfile.windows`: Pipeline específico para entornos Windows
- `ci/jenkins.env`: Variables de entorno para Jenkins
- `ci/terraform-jenkins-deploy.yaml`: Plantilla CloudFormation para integración AWS

## Requisitos previos

1. **Jenkins configurado con**:
   - Plugin de Pipeline instalado
   - Plugin de Docker (si usas Jenkinsfile.docker)
   - Terraform instalado en el agente Jenkins

2. **Permisos**:
   - Jenkins debe tener permisos para ejecutar Terraform
   - Jenkins debe poder acceder al Docker Engine (si corresponde)

## Configuración del Pipeline

### Crear un nuevo Pipeline en Jenkins

1. En Jenkins, ir a "Nueva Tarea" 
2. Seleccionar "Pipeline"
3. Configurar el origen como SCM Git
4. Especificar el repositorio y las credenciales
5. Elegir la rama adecuada
6. En "Script Path", especificar uno de los siguientes (según tus necesidades):
   - `ci/Jenkinsfile` (por defecto)
   - `ci/Jenkinsfile.windows` (para Windows)
   - `ci/Jenkinsfile.docker` (si usas Docker)

### Configuración de parámetros

El pipeline está configurado para aceptar los siguientes parámetros:

- `TERRAFORM_ACTION`: Acción a ejecutar (plan, apply, destroy)
- `CONTAINER_NAME`: Nombre del contenedor Docker
- `EXTERNAL_PORT`: Puerto externo para mapear 
- `IMAGE_NAME`: Nombre de la imagen Docker a utilizar

### Variables de entorno

Las variables de entorno se deben configurar en Jenkins según el archivo `ci/jenkins.env`. Puedes agregarlas como:

1. Variables globales en Jenkins
2. Variables de entorno a nivel del pipeline
3. Credenciales en Jenkins

## Solución de problemas

### Error "Cannot run program 'sh'" en Windows

Si encuentras este error, asegúrate de:

1. Usar el Jenkinsfile correcto para Windows (`ci/Jenkinsfile.windows`)
2. Reemplazar comandos `sh` por `bat` o `powershell` 
3. Usar la continuación de línea correcta (`^` en lugar de `\`)

### Problemas con Docker en Windows

Si usas Docker en Windows con Jenkins:

1. Asegúrate de que Docker Desktop está en modo Windows containers o Linux containers según corresponda
2. Verifica que el usuario de Jenkins tiene permisos para acceder al socket de Docker
3. Considera usar el archivo `ci/Jenkinsfile.docker-windows` específicamente diseñado para este escenario

### Error con Terraform

1. Verifica que Terraform está instalado y disponible en el PATH
2. Asegúrate de que Jenkins tiene permisos para ejecutar Terraform
3. Prueba ejecutar el script PowerShell manualmente: `.\scripts\jenkins-terraform.ps1`
