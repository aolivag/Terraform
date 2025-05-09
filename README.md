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
   - Para Windows, tienes tres opciones: 
     - **Recomendado**: Usar "Jenkinsfile" (basado en PowerShell) adaptado para Windows
     - Usar "Jenkinsfile.docker-windows" si necesitas ejecutar en un contenedor Windows
     - Usar "Jenkinsfile.docker" para entornos donde Docker funciona correctamente con Jenkins

3. **Variables de entorno**:
   - Puedes cargar las variables del archivo `jenkins.env` en la configuración de Jenkins

### Ejecución manual desde PowerShell

También puedes ejecutar el script de PowerShell directamente (recomendado para entornos Windows):

```powershell
.\jenkins-terraform.ps1 -Action apply -ContainerName webapp -ExternalPort 8080 -ImageName nginx:alpine
```

### Solución a errores comunes en Windows

- Si encuentras el error "Cannot run program 'sh'", esto puede ocurrir por varios motivos:
  1. **Usando el Jenkinsfile equivocado**: Asegúrate de usar el Jenkinsfile adaptado para Windows (con comandos `bat` o `powershell` en lugar de `sh`)
  2. **Agente Docker en Windows**: Si estás usando un agente Docker dentro de Jenkins en Windows, necesitarás:
     - Usar "Jenkinsfile.docker-windows" específicamente creado para este escenario
     - O usar el "Jenkinsfile" actual que utiliza PowerShell directamente
  3. **Problemas de PATH**: Asegúrate de que el PATH incluya la ruta a Terraform correctamente con separador ';' en lugar de ':'
- En los comandos de línea continua en Windows, usa el carácter `^` en lugar de `\`
- Si sigues teniendo problemas, puedes usar alguna de estas alternativas:
  - `Jenkinsfile.ps1`: Utiliza un script PowerShell dedicado para ejecutar Terraform (solución más robusta)
  - `Jenkinsfile.full`: Versión completa con comandos `bat` específicos para Windows
  - `Jenkinsfile.simple`: Versión minimalista para pruebas

### Método recomendado para Windows

Para entornos Windows, recomendamos utilizar el enfoque basado en PowerShell:

1. Asegúrate de que Terraform está instalado y accesible en el PATH
2. Usa el archivo `Jenkinsfile` (que llama al script `jenkins-terraform-windows.ps1`)
3. Configura el job de Jenkins para usar este archivo

### Integración con AWS Lambda

Si deseas integrar con AWS, puedes desplegar la plantilla CloudFormation incluida:

```powershell
aws cloudformation deploy --template-file terraform-jenkins-deploy.yaml --stack-name terraform-jenkins-integration --capabilities CAPABILITY_IAM
```

Esto creará una Lambda que puede iniciar trabajos de Jenkins para desplegar la infraestructura de Terraform.
