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


    
        stage('Apply Ansible') {
    steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
            withCredentials([sshUserPrivateKey(credentialsId: 'ssh_key_id', keyFileVariable: 'SSH_PRIVATE_KEY')]) {  
                script {
                    // Créer un fichier temporaire pour la clé privée
                    writeFile file: '/tmp/ssh_private_key.pem', text: "${SSH_PRIVATE_KEY}"

                    // Assurer les bonnes permissions pour la clé privée
                    sh 'chmod 600 /tmp/ssh_private_key.pem'

                    // Récupérer l'IP publique de l'instance EC2
                    def public_ip = sh(script: "cd /var/lib/jenkins/workspace/Projet1/terraform && terraform output -raw public_ip", returnStdout: true).trim()

                    // Créer le fichier inventory.ini dynamique basé sur l'IP publique
                    writeFile file: '/var/lib/jenkins/workspace/Projet1/terraform/inventory.ini', text: """
[webservers]
${public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/tmp/ssh_private_key.pem
"""

                            // Exécuter le playbook Ansible pour installer et configurer NGINX
                            sh """
                            ansible-playbook -i /var/lib/jenkins/workspace/Projet1/terraform/inventory.ini /var/lib/jenkins/workspace/Projet1/Ansible/nginx_docker.yml --extra-vars "ansible_ssh_private_key_file=/tmp/ssh_private_key.pem ansible_user=ubuntu"
                            """
                        }
                    }
                }
            }
        }

            
        stage('Test Server') {
            steps {
                script {
                    // Tester si NGINX est bien accessible sur l'instance EC2
                    def instance_ip = sh(script: "cd /var/lib/jenkins/workspace/Projet1/terraform && terraform output -raw public_ip", returnStdout: true).trim()
                    sh "curl -I http://${instance_ip}"
                }
            }
        }


    }
    
    post {
        success {
            echo 'Le serveur web NGINX a été déployé avec succès !'
        }
        failure {
            echo 'Une erreur est survenue lors du déploiement du serveur web.'
        }
    }
}