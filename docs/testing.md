# Pruebas de Terraform

Este documento proporciona información sobre cómo probar la configuración de Terraform antes de su despliegue.

## Pruebas con el Pipeline de Jenkins

El archivo `Jenkinsfile.full` incluye una etapa específica de pruebas que valida:
- Formato correcto de los archivos Terraform
- Validación sintáctica de las configuraciones
- Validación de referencias de variables y recursos

## Pruebas locales

Para ejecutar pruebas localmente antes de hacer commit:

```powershell
# Validar la sintaxis de los archivos Terraform
cd environments/dev
terraform validate

# Verificar el formato de los archivos
terraform fmt -check

# Realizar un plan sin aplicar cambios
terraform plan
```

## Integración con herramientas de pruebas

Esta configuración de Terraform puede integrarse con las siguientes herramientas para pruebas automatizadas:

1. **TFLint**: Herramienta de linting para Terraform
   ```powershell
   tflint environments/dev
   ```

2. **Checkov**: Herramienta de análisis estático para Terraform
   ```powershell
   checkov -d environments/dev
   ```

3. **Terratest**: Marco de pruebas en Go para Terraform
   - Crea pruebas en Go que configuren, apliquen y verifiquen tu infraestructura

## Notas sobre pruebas de Docker con Terraform

Al probar configuraciones que gestionan contenedores Docker:
- Asegura que Docker esté instalado y en ejecución antes de ejecutar las pruebas
- Considera usar contenedores efímeros solo para pruebas con etiquetas distintas
- Verifica que los puertos utilizados en las pruebas no estén en uso
