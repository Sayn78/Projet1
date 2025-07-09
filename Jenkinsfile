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
    
      

        stage('Check Vulnerabilities') {
            steps {
                echo "🔍 npm audit"
                sh 'npm audit || true' // pour éviter l'échec en cas de vulnérabilité
                sh 'npm audit fix || true'
            }
         }

        stage('Clean Install') {
            steps {
                echo "📦 Installation propre avec npm ci"
                sh 'npm ci'
            }
        }

        
        stage('Formating & Linting') {
            steps {
                echo "🎨 Vérification du formatage et du linting"

                dir('Projet1') {
                    // Vérifie le formatage avec prettier (optionnel)
                    sh 'npm run format:check || true'

                    // Lint du projet
                    sh 'npm run lint'
                }
            }
        }

        stage('Unit Tests') {
            steps {
                dir('Projet1') {
                    echo "🧪 Lancement des tests unitaires"
                    sh 'npm run test'
                }
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
