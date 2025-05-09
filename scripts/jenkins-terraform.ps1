# jenkins-terraform.ps1
# Script para ejecutar Terraform en entorno Jenkins con Windows

param(
    [string]$Action = "plan",
    [string]$ContainerName = "terraform-docker-demo",
    [int]$ExternalPort = 8000,
    [string]$ImageName = "nginx:latest",
    [string]$Environment = "dev"
)

Write-Host "Ejecutando Terraform $Action en Jenkins..." -ForegroundColor Cyan

# Verificar instalación de Terraform
try {
    $terraformVersion = terraform version
    Write-Host "Versión de Terraform: $terraformVersion" -ForegroundColor Green
}
catch {
    Write-Host "Error: Terraform no está instalado o no está en el PATH" -ForegroundColor Red
    exit 1
}

# Verificar que Docker esté disponible
try {
    $dockerInfo = docker info
    Write-Host "Docker está disponible" -ForegroundColor Green
}
catch {
    Write-Host "Advertencia: Docker no está disponible o no está en ejecución" -ForegroundColor Yellow
    Write-Host "Asegúrate de que Docker esté instalado y en ejecución en el agente de Jenkins" -ForegroundColor Yellow
}

# Establecer directorio de trabajo según el entorno
$workingDir = "../environments/$Environment"
Set-Location -Path $workingDir

Write-Host "Trabajando en el directorio: $((Get-Location).Path)" -ForegroundColor Yellow

# Inicializar Terraform
Write-Host "Inicializando Terraform..." -ForegroundColor Cyan
terraform init

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al inicializar Terraform" -ForegroundColor Red
    exit $LASTEXITCODE
}

# Validar la configuración
Write-Host "Validando la configuración de Terraform..." -ForegroundColor Cyan
terraform validate

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error en la validación de Terraform" -ForegroundColor Red
    exit $LASTEXITCODE
}

# Ejecutar la acción especificada
switch ($Action) {
    "plan" {
        Write-Host "Generando plan de Terraform..." -ForegroundColor Cyan
        terraform plan -out=tfplan `
            -var="container_name=$ContainerName" `
            -var="external_port=$ExternalPort" `
            -var="image_name=$ImageName"
    }
    "apply" {
        Write-Host "Aplicando configuración de Terraform..." -ForegroundColor Cyan
        
        # Primero generamos el plan si no existe
        if (-not (Test-Path -Path "./tfplan")) {
            terraform plan -out=tfplan `
                -var="container_name=$ContainerName" `
                -var="external_port=$ExternalPort" `
                -var="image_name=$ImageName"
        }
        
        terraform apply -auto-approve tfplan
        
        # Mostrar información de salida
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Despliegue completado correctamente" -ForegroundColor Green
            Write-Host "Información del contenedor:" -ForegroundColor Cyan
            terraform output
        }
    }
    "destroy" {
        Write-Host "Destruyendo infraestructura..." -ForegroundColor Yellow
        terraform destroy -auto-approve `
            -var="container_name=$ContainerName" `
            -var="external_port=$ExternalPort" `
            -var="image_name=$ImageName"
    }
    default {
        Write-Host "Acción no reconocida: $Action" -ForegroundColor Red
        Write-Host "Acciones válidas: plan, apply, destroy" -ForegroundColor Yellow
        exit 1
    }
}

exit $LASTEXITCODE
