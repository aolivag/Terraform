pipeline {
    agent any
      environment {
        // Definir variables de entorno para el pipeline
        TERRAFORM_HOME = tool 'terraform'
        PATH = "${env.TERRAFORM_HOME};${env.PATH}"  // Separador de ruta en Windows es punto y coma
    }
    
    parameters {
        // Parámetros que se pueden configurar en la interfaz de Jenkins
        choice(name: 'TERRAFORM_ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Acción a ejecutar en Terraform')
        string(name: 'CONTAINER_NAME', defaultValue: 'terraform-docker-demo', description: 'Nombre del contenedor Docker')
        string(name: 'EXTERNAL_PORT', defaultValue: '8000', description: 'Puerto externo para mapear al contenedor')
        string(name: 'IMAGE_NAME', defaultValue: 'nginx:latest', description: 'Nombre de la imagen Docker a utilizar')
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Obtener el código del repositorio
                checkout scm
            }
        }
          stage('Terraform Init') {
            steps {
                // Inicializar Terraform (usando PowerShell en Windows)
                bat 'terraform init'
            }
        }
        
        stage('Terraform Validate') {
            steps {
                // Validar la sintaxis de los archivos de Terraform
                bat 'terraform validate'
            }
        }
          stage('Terraform Plan') {
            steps {
                // Generar el plan de Terraform con variables personalizadas (usando PowerShell en Windows)
                bat """
                terraform plan -out=tfplan ^
                    -var="container_name=${params.CONTAINER_NAME}" ^
                    -var="external_port=${params.EXTERNAL_PORT}" ^
                    -var="image_name=${params.IMAGE_NAME}"
                """
            }
        }        stage('Terraform Apply/Destroy') {
            when {
                expression { params.TERRAFORM_ACTION == 'apply' || params.TERRAFORM_ACTION == 'destroy' }
            }
            steps {
                script {
                    if (params.TERRAFORM_ACTION == 'apply') {
                        // Aplicar el plan de Terraform
                        bat 'terraform apply -auto-approve tfplan'
                    } else if (params.TERRAFORM_ACTION == 'destroy') {
                        // Destruir la infraestructura
                        bat """
                        terraform destroy -auto-approve ^
                            -var="container_name=${params.CONTAINER_NAME}" ^
                            -var="external_port=${params.EXTERNAL_PORT}" ^
                            -var="image_name=${params.IMAGE_NAME}"
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Limpiar el espacio de trabajo
            cleanWs()
        }
        success {
            echo 'Pipeline ejecutado correctamente'
        }
        failure {
            echo 'Pipeline fallido'
        }
    }
}
