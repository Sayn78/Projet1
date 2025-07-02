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

        stage('Test Terraform Apply') {
            steps {
                script {

                    if (instance_id == "") {
                        error "L'instance EC2 n'a pas été créée ou n'est pas disponible."
                    } else {
                        echo "Instance EC2 avec ID: ${instance_id} créée avec succès."
                    }
                }
            }
        }




    
        stage('Apply Ansible') {
    steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {              
                script {

                    // Récupérer l'IP publique de l'instance EC2
                    def public_ip = sh(script: "cd /var/lib/jenkins/workspace/Projet1/terraform && terraform output -raw public_ip", returnStdout: true).trim()

                    // Créer le fichier inventory.ini dynamique basé sur l'IP publique
                    writeFile file: '/var/lib/jenkins/workspace/Projet1/terraform/inventory.ini', text: """
[webservers]
${public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/workspace/Projet1/sshsenan.pem
"""

                            // Exécuter le playbook Ansible pour installer et configurer NGINX
                            sh """
                            ansible-playbook -i /var/lib/jenkins/workspace/Projet1/terraform/inventory.ini /var/lib/jenkins/workspace/Projet1/Ansible/nginx_docker.yml --extra-vars "ansible_ssh_private_key_file=/var/lib/jenkins/workspace/Projet1/sshsenan.pem ansible_user=ubuntu"
                            """
                        }
                    }
                }
        }


        stage('Validate Public IP') {
            steps {
                script {
                    // Vérifier si l'IP publique existe
                    def public_ip = sh(script: "cd /var/lib/jenkins/workspace/Projet1/terraform && terraform output -raw public_ip", returnStdout: true).trim()
                    if (!public_ip) {
                        error "L'IP publique de l'instance EC2 n'a pas été générée."
                    }
                    echo "L'IP publique est : ${public_ip}"
                }
            }
        }


        stage('Test NGINX Installation') {
            steps {
                script {
                    // Tester si NGINX fonctionne correctement sur l'instance
                    def public_ip = sh(script: "cd /var/lib/jenkins/workspace/Projet1/terraform && terraform output -raw public_ip", returnStdout: true).trim()
                    def nginx_status = sh(script: "ssh -i /var/lib/jenkins/workspace/Projet1/sshsenan.pem -o StrictHostKeyChecking=no ubuntu@${public_ip} 'systemctl is-active nginx'", returnStdout: true).trim()

                    if (nginx_status != "active") {
                        error "NGINX ne fonctionne pas correctement sur l'instance EC2."
                    } else {
                        echo "NGINX fonctionne correctement sur l'instance EC2."
                    }
                }
            }
        }



            
        stage('Test NGINX Server') {
            steps {
                script {
                    def instance_ip = sh(script: "cd /var/lib/jenkins/workspace/Projet1/terraform && terraform output -raw public_ip", returnStdout: true).trim()
                    def response = sh(script: "curl -s -o /dev/null -w \"%{http_code}\" http://${instance_ip}", returnStdout: true).trim()

                    if (response != "200") {
                        error "Le serveur NGINX ne répond pas correctement (Code HTTP: ${response})."
                    } else {
                        echo "Le serveur NGINX fonctionne correctement avec le code HTTP: ${response}."
                    }
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