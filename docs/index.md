# Documentación del Proyecto Terraform con Docker

## Visión general

Este proyecto proporciona una estructura modular para gestionar contenedores Docker utilizando Terraform y su integración con Jenkins para CI/CD.

## Estructura del proyecto

El proyecto sigue una arquitectura modular que permite la reutilización de componentes y la separación de configuraciones específicas por entorno:

- **Módulos**: Componentes reutilizables de Terraform
- **Entornos**: Configuraciones específicas para dev/prod
- **CI**: Archivos de integración continua (Jenkins)
- **Scripts**: Utilidades para automatización

## Módulos disponibles

### Módulo Docker

El módulo Docker (`modules/docker`) permite gestionar contenedores Docker con Terraform:

- **Funcionalidades**:
  - Creación y gestión de contenedores
  - Configuración de redes y puertos
  - Políticas de reinicio y health checks

- **Variables principales**:
  - `container_name`: Nombre del contenedor
  - `external_port`: Puerto externo a exponer
  - `image_name`: Imagen Docker a utilizar

## Configuración de entornos

### Entorno de desarrollo (dev)

- **Ubicación**: `environments/dev`
- **Configuraciones predeterminadas**:
  - Puerto: 8000
  - Imagen: nginx:latest

### Entorno de producción (prod)

- **Ubicación**: `environments/prod`
- **Configuraciones predeterminadas**:
  - Puerto: 80
  - Imagen: nginx:stable

## Integración con Jenkins

### Archivos disponibles

- `ci/Jenkinsfile`: Pipeline genérico
- `ci/Jenkinsfile.docker`: Pipeline utilizando Docker
- `ci/Jenkinsfile.windows`: Pipeline adaptado para Windows

### Configuración en Jenkins

1. Crear un nuevo Pipeline en Jenkins
2. Configurar el origen como SCM Git
3. Especificar la ruta al Jenkinsfile adecuado (según el entorno)
4. Configurar las variables de entorno según `ci/jenkins.env`

### Solución de problemas comunes

Consulta la sección de solución de problemas en el README principal para:
- Error "Cannot run program 'sh'"
- Problemas con Docker en Windows
- Problemas con permisos de Terraform
