# jenkins-terraform-windows.ps1
# Script de PowerShell específico para entornos Jenkins en Windows

param (
    [ValidateSet("init", "plan", "apply", "destroy")]
    [string]$Action = "plan",
    
    [string]$ContainerName = "terraform-docker-demo",
    
    [int]$ExternalPort = 8000,
    
    [string]$ImageName = "nginx:latest"
)

# Configurar la salida para ser más visible en la consola de Jenkins
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host "===> $Message" -ForegroundColor $Color
}

# Configurar el entorno
$ErrorActionPreference = "Stop"
Write-ColorOutput "Iniciando operación Terraform: $Action" "Cyan"
Write-ColorOutput "Parámetros:" "Yellow"
Write-ColorOutput "  - Contenedor: $ContainerName" "Yellow"
Write-ColorOutput "  - Puerto: $ExternalPort" "Yellow"
Write-ColorOutput "  - Imagen: $ImageName" "Yellow"

# Verificar que Terraform está instalado
try {
    $tfVersion = terraform --version
    Write-ColorOutput "Versión de Terraform: $tfVersion" "Green"
}
catch {
    Write-ColorOutput "ERROR: Terraform no está instalado o no está en el PATH" "Red"
    exit 1
}

# Función para ejecutar comandos con manejo de errores
function Invoke-CommandWithErrorHandling {
    param(
        [string]$Command,
        [string]$Description
    )
    
    Write-ColorOutput $Description "Cyan"
    
    # Convertir el comando a un bloque scriptblock y ejecutarlo
    try {
        $scriptBlock = [scriptblock]::Create($Command)
        & $scriptBlock
        
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "ERROR: El comando falló con código de salida $LASTEXITCODE" "Red"
            exit $LASTEXITCODE
        }
    }
    catch {
        Write-ColorOutput "ERROR: Excepción al ejecutar el comando - $_" "Red"
        exit 1
    }
}

# Inicializar Terraform siempre
Invoke-CommandWithErrorHandling -Command "terraform init" -Description "Inicializando Terraform"

# Ejecutar la operación correspondiente
switch ($Action) {
    "init" {
        # Inicialización ya realizada
        Write-ColorOutput "Inicialización completada correctamente" "Green"
    }
    
    "plan" {
        Invoke-CommandWithErrorHandling -Command "terraform validate" -Description "Validando configuración"
        
        $planCommand = "terraform plan -out=tfplan " + `
                      "-var=`"container_name=$ContainerName`" " + `
                      "-var=`"external_port=$ExternalPort`" " + `
                      "-var=`"image_name=$ImageName`""
                      
        Invoke-CommandWithErrorHandling -Command $planCommand -Description "Generando plan de despliegue"
        Write-ColorOutput "Plan generado correctamente y guardado en 'tfplan'" "Green"
    }
    
    "apply" {
        # Verificar si existe un plan
        if (Test-Path -Path "tfplan") {
            Invoke-CommandWithErrorHandling -Command "terraform apply -auto-approve tfplan" -Description "Aplicando plan existente"
        }
        else {
            Write-ColorOutput "No se encontró un archivo de plan. Generando y aplicando plan..." "Yellow"
            
            $applyCommand = "terraform apply -auto-approve " + `
                           "-var=`"container_name=$ContainerName`" " + `
                           "-var=`"external_port=$ExternalPort`" " + `
                           "-var=`"image_name=$ImageName`""
                           
            Invoke-CommandWithErrorHandling -Command $applyCommand -Description "Aplicando configuración"
        }
        
        # Mostrar los outputs
        Invoke-CommandWithErrorHandling -Command "terraform output" -Description "Mostrando información de salida"
        Write-ColorOutput "Infraestructura desplegada correctamente" "Green"
    }
    
    "destroy" {
        $destroyCommand = "terraform destroy -auto-approve " + `
                         "-var=`"container_name=$ContainerName`" " + `
                         "-var=`"external_port=$ExternalPort`" " + `
                         "-var=`"image_name=$ImageName`""
                         
        Invoke-CommandWithErrorHandling -Command $destroyCommand -Description "Destruyendo infraestructura"
        Write-ColorOutput "Infraestructura destruida correctamente" "Green"
    }
}

Write-ColorOutput "Operación completada exitosamente" "Green"
