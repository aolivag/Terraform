# Terraform con Docker

Este proyecto demuestra cómo usar Terraform para administrar recursos de Docker.

## Requisitos previos

- [Terraform](https://www.terraform.io/downloads.html) (versión 1.0.0 o superior)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) instalado y en ejecución

## Estructura del proyecto

```
.
├── main.tf         # Configuración principal de Terraform
├── variables.tf    # Definiciones de variables
├── outputs.tf      # Definiciones de salidas
├── versions.tf     # Requisitos de versión de Terraform
└── README.md       # Este archivo
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
