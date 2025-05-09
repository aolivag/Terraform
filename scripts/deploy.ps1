# deploy.ps1
# Script para inicializar y desplegar recursos de Terraform con Docker

Write-Host "Verificando que Docker esté en ejecución..." -ForegroundColor Cyan
try {
    $dockerStatus = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Docker no está en ejecución"
    }
    Write-Host "Docker está en ejecución correctamente" -ForegroundColor Green
}
catch {
    Write-Host "Error: Docker no está en ejecución o no está instalado." -ForegroundColor Red
    Write-Host "Por favor, inicia Docker Desktop y vuelve a ejecutar este script." -ForegroundColor Red
    exit 1
}

Write-Host "`nInicializando Terraform..." -ForegroundColor Cyan
terraform init

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nGenerando plan de ejecución..." -ForegroundColor Cyan
    terraform plan -out=tfplan

    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n¿Deseas aplicar este plan? (s/n)" -ForegroundColor Yellow
        $respuesta = Read-Host
        if ($respuesta -eq "s") {
            Write-Host "`nAplicando plan..." -ForegroundColor Cyan
            terraform apply tfplan
              if ($LASTEXITCODE -eq 0) {
                Write-Host "`nRecursos desplegados correctamente." -ForegroundColor Green
                Write-Host "Para acceder al contenedor, abre $(terraform output -raw container_access_url)" -ForegroundColor Cyan
            }
        }
        else {
            Write-Host "`nOperación cancelada por el usuario." -ForegroundColor Yellow
        }
    }
}
