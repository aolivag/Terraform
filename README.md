# Terraform con Docker

Este proyecto demuestra cómo usar Terraform para administrar recursos de Docker.

## Requisitos previos

- [Terraform](https://www.terraform.io/downloads.html) (versión 1.0.0 o superior)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) instalado y en ejecución

## Estructura del proyecto

```
.
├── ci/                           # Archivos de integración continua
│   ├── Jenkinsfile               # Pipeline de Jenkins para Terraform
│   ├── Jenkinsfile.docker        # Pipeline de Jenkins usando Docker
│   ├── Jenkinsfile.windows       # Pipeline adaptado para Windows
│   ├── jenkins.env               # Variables de entorno para Jenkins
│   └── terraform-jenkins-deploy.yaml # Plantilla CloudFormation para integración AWS
├── docs/                         # Documentación detallada del proyecto
├── environments/                 # Configuraciones específicas por ambiente
│   ├── dev/                      # Ambiente de desarrollo
│   └── prod/                     # Ambiente de producción
├── modules/                      # Módulos reutilizables de Terraform
│   └── docker/                   # Módulo para gestionar contenedores Docker
│       ├── main.tf               # Configuración principal del módulo Docker
│       ├── variables.tf          # Definiciones de variables del módulo
│       └── outputs.tf            # Definiciones de salidas del módulo
├── scripts/                      # Scripts de automatización
│   ├── deploy.ps1                # Script para despliegue local
│   └── jenkins-terraform.ps1     # Script PowerShell para Jenkins
└── README.md                     # Este archivo
```

## Inicialización y uso

### Enfoque modular (recomendado)

1. Navega al directorio del ambiente que deseas utilizar:

```powershell
cd environments/dev  # Para ambiente de desarrollo
# o
cd environments/prod # Para ambiente de producción
```

2. Inicializar el proyecto Terraform:

```powershell
terraform init
```

3. Ver el plan de ejecución:

```powershell
terraform plan
```

4. Aplicar la configuración:

```powershell
terraform apply
```

5. Cuando ya no necesites los recursos, puedes destruirlos:

```powershell
terraform destroy
```

## Personalización

Puedes modificar los valores predeterminados en el archivo `variables.tf` o pasar variables durante la ejecución:

```powershell
terraform apply -var="external_port=8080" -var="container_name=mi-contenedor"
```

También puedes crear un archivo `terraform.tfvars` para establecer valores personalizados.

## Integración con Jenkins

Este proyecto incluye archivos de configuración para integrarse con Jenkins, permitiendo automatizar el despliegue de la infraestructura.

### Configuración en Jenkins (Windows)

1. **Requisitos en Jenkins**:
   - Plugin de Pipeline instalado
   - Plugin de Docker instalado (si usas `Jenkinsfile.docker`)
   - Terraform instalado en el agente Jenkins y disponible en el PATH
   - Para entornos Windows, usa `Jenkinsfile.windows` o el `Jenkinsfile` actualizado

2. **Crear un nuevo pipeline en Jenkins**:
   - Crea un nuevo elemento de tipo Pipeline
   - En la sección "Pipeline", selecciona "Pipeline script from SCM"
   - Selecciona Git como SCM
   - Ingresa la URL de tu repositorio
   - Para Windows, tienes tres opciones: 
     - **Recomendado**: Usar "Jenkinsfile" (basado en PowerShell) adaptado para Windows
     - Usar "Jenkinsfile.docker-windows" si necesitas ejecutar en un contenedor Windows
     - Usar "Jenkinsfile.docker" para entornos donde Docker funciona correctamente con Jenkins

3. **Variables de entorno**:
   - Puedes cargar las variables del archivo `jenkins.env` en la configuración de Jenkins

### Ejecución manual desde PowerShell

También puedes ejecutar el script de PowerShell directamente (recomendado para entornos Windows):

```powershell
.\scripts\jenkins-terraform.ps1 -Action apply -ContainerName webapp -ExternalPort 8080 -ImageName nginx:alpine
```

O utilizar el script de despliegue local:

```powershell
.\scripts\deploy.ps1 -Environment dev -Action apply
```

### Solución a errores comunes en Windows

- Si encuentras el error "Cannot run program 'sh'", esto puede ocurrir por varios motivos:
  1. **Usando el Jenkinsfile equivocado**: Asegúrate de usar el Jenkinsfile adaptado para Windows (con comandos `bat` o `powershell` en lugar de `sh`)
  2. **Agente Docker en Windows**: Si estás usando un agente Docker dentro de Jenkins en Windows, necesitarás:
     - Usar "Jenkinsfile.docker-windows" específicamente creado para este escenario
     - O usar "Jenkinsfile" actual que no intenta utilizar Docker como agente
  3. **Problemas de PATH**: Asegúrate de que el PATH incluya la ruta a Terraform correctamente con separador ';' en lugar de ':'
- En los comandos de línea continua en Windows, usa el carácter `^` en lugar de `\`
- Si sigues teniendo problemas, considera ejecutar Jenkins en un contenedor Docker basado en Linux

### Integración con AWS Lambda

Si deseas integrar con AWS, puedes desplegar la plantilla CloudFormation incluida:

```powershell
aws cloudformation deploy --template-file terraform-jenkins-deploy.yaml --stack-name terraform-jenkins-integration --capabilities CAPABILITY_IAM
```

Esto creará una Lambda que puede iniciar trabajos de Jenkins para desplegar la infraestructura de Terraform.
