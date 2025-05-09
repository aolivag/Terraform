pipeline {
    agent any
    
    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Acción a ejecutar en Terraform')
        string(name: 'CONTAINER_NAME', defaultValue: 'terraform-docker-demo', description: 'Nombre del contenedor Docker')
        string(name: 'EXTERNAL_PORT', defaultValue: '8000', description: 'Puerto externo para mapear al contenedor')
        string(name: 'IMAGE_NAME', defaultValue: 'nginx:latest', description: 'Nombre de la imagen Docker a utilizar')
    }
    
    stages {
        stage('Verify Environment') {
            steps {
                bat 'echo Environment verification'
                bat 'terraform --version'
                bat 'dir'
            }
        }
        
        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            when {
                expression { return params.TERRAFORM_ACTION != 'destroy' }
            }
            steps {
                bat """
                terraform plan -out=tfplan ^
                -var="container_name=${params.CONTAINER_NAME}" ^
                -var="external_port=${params.EXTERNAL_PORT}" ^
                -var="image_name=${params.IMAGE_NAME}"
                """
            }
        }
        
        stage('Terraform Apply') {
            when {
                expression { return params.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                bat 'terraform apply -auto-approve tfplan'
            }
        }
        
        stage('Terraform Destroy') {
            when {
                expression { return params.TERRAFORM_ACTION == 'destroy' }
            }
            steps {
                bat """
                terraform destroy -auto-approve ^
                -var="container_name=${params.CONTAINER_NAME}" ^
                -var="external_port=${params.EXTERNAL_PORT}" ^
                -var="image_name=${params.IMAGE_NAME}"
                """
            }
        }
    }
    
    post {
        always {
            echo 'Limpiando espacio de trabajo'
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
