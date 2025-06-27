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

        stage('Initialize Terraform') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    script {
                        // Se déplacer dans le répertoire Projet1/terraform
                        sh 'cd ~/workspace/Projet1/terraform/ && ls -la'  // Vérifier que le répertoire terraform existe et lister les fichiers
                        sh 'cd ~/workspace/Projet1/terraform/ && terraform init'  // Initialisation de Terraform
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    script {
                        // Appliquer la configuration Terraform
                        sh 'cd ~/workspace/Projet1/terraform/ && terraform apply -auto-approve'  // Appliquer la configuration Terraform
                    }
                }
            }
        }

        stage('Test Server') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    script {
                        sh 'curl http://<public-ip-de-ton-instance>'  // Exemple de test pour vérifier l'instance
                    }
                }
            }
        }
    }
}
