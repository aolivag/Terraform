# Terraform con Docker

Este proyecto demuestra cómo usar Terraform para administrar recursos de Docker.

## Requisitos previos

- [Terraform](https://www.terraform.io/downloads.html) (versión 1.0.0 o superior)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) instalado y en ejecución

## Estructura del proyecto

```
.
├── main.tf                       # Configuración principal de Terraform
├── variables.tf                  # Definiciones de variables
├── outputs.tf                    # Definiciones de salidas
├── versions.tf                   # Requisitos de versión de Terraform
├── Jenkinsfile                   # Pipeline de Jenkins para Terraform
├── Jenkinsfile.docker            # Pipeline de Jenkins usando Docker
├── jenkins-terraform.ps1         # Script PowerShell para Jenkins
├── jenkins.env                   # Variables de entorno para Jenkins
├── terraform-jenkins-deploy.yaml # Plantilla CloudFormation para integración AWS
└── README.md                     # Este archivo
```

## Inicialización y uso

1. Inicializar el proyecto Terraform:

```powershell
terraform init
```

2. Ver el plan de ejecución:

```powershell
terraform plan
```

3. Aplicar la configuración:

```powershell
terraform apply
```

4. Cuando ya no necesites los recursos, puedes destruirlos:

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
   - Para Windows: 
     - Usar "Jenkinsfile.windows" como ruta del script (basado en PowerShell)
     - O usar "Jenkinsfile" que ha sido adaptado para usar comandos `bat` en lugar de `sh`

3. **Variables de entorno**:
   - Puedes cargar las variables del archivo `jenkins.env` en la configuración de Jenkins

### Ejecución manual desde PowerShell

También puedes ejecutar el script de PowerShell directamente (recomendado para entornos Windows):

```powershell
.\jenkins-terraform.ps1 -Action apply -ContainerName webapp -ExternalPort 8080 -ImageName nginx:alpine
```

### Solución a errores comunes en Windows

- Si encuentras el error "Cannot run program 'sh'", asegúrate de usar el Jenkinsfile adaptado para Windows (con comandos `bat` o `powershell` en lugar de `sh`)
- Asegúrate de que el PATH incluya la ruta a Terraform correctamente con separador ';' en lugar de ':'
- En los comandos de línea continua en Windows, usa el carácter `^` en lugar de `\`

### Integración con AWS Lambda

Si deseas integrar con AWS, puedes desplegar la plantilla CloudFormation incluida:

```powershell
aws cloudformation deploy --template-file terraform-jenkins-deploy.yaml --stack-name terraform-jenkins-integration --capabilities CAPABILITY_IAM
```

Esto creará una Lambda que puede iniciar trabajos de Jenkins para desplegar la infraestructura de Terraform.
