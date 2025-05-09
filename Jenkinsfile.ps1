pipeline {
    agent any
    
    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Acción a ejecutar en Terraform')
        string(name: 'CONTAINER_NAME', defaultValue: 'terraform-docker-demo', description: 'Nombre del contenedor Docker')
        string(name: 'EXTERNAL_PORT', defaultValue: '8000', description: 'Puerto externo para mapear al contenedor')
        string(name: 'IMAGE_NAME', defaultValue: 'nginx:latest', description: 'Nombre de la imagen Docker a utilizar')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Run PowerShell Script') {
            steps {
                powershell """
                    .\\jenkins-terraform-windows.ps1 -Action ${params.TERRAFORM_ACTION} -ContainerName '${params.CONTAINER_NAME}' -ExternalPort ${params.EXTERNAL_PORT} -ImageName '${params.IMAGE_NAME}'
                """
            }
        }
    }
    
    post {
        always {
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
