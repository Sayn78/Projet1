pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'eu-west-3'  // Région AWS que tu utilises
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Cloner le dépôt GitHub dans le répertoire de travail Jenkins
                git branch: 'main', url: 'https://github.com/Sayn78/Projet1.git'  // Remplace par l'URL de ton dépôt
            }
        }
    }
      
        stages {
            stage('Check Vulnerabilities') {
                steps {
                    echo "🔍 npm audit"
                    sh 'npm audit || true' // pour éviter l'échec en cas de vulnérabilité
                    sh 'npm audit fix || true'
                }
            }
        }

    post {
        always {
            echo '🏁 Pipeline finished'
        }
        failure {
            echo '❌ Pipeline failed'
        }
        success {
            echo '✅ Pipeline succeeded'
        }
    }
}
