pipeline {
    agent any
    
    stages {
        stage('Run Windows Command') {
            steps {
                // Usar 'bat' que es el shell nativo en Windows
                bat 'echo Test de Windows > test.txt'
            }
        }
    }
}