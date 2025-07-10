pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'eu-west-3'  // Région AWS que tu utilises
        DOCKER_IMAGE = "sayn78300/mon-site"
        DOCKER_TAG = "1.0.0"
        INVENTORY_FILE = "Ansible/inventory.ini"
        KEY_PATH = "~/.ssh/sshsenan.pem"
    }

    stages {


        stage('Checkout Code') {
            steps {
                // Cloner le dépôt GitHub dans le répertoire de travail Jenkins
                git branch: 'main', url: 'https://github.com/Sayn78/Projet1.git'  // Remplace par l'URL de ton dépôt
            }
        }


        stage('Terraform') {
            environment {
                TERRAFORM_DIR = "${WORKSPACE}/terraform"
                INVENTORY_FILE = "${WORKSPACE}/Ansible/inventory.ini"
            }

            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    script {
                        echo "📁 Listing du répertoire Terraform"
                        sh "ls -la ${TERRAFORM_DIR}"

                        echo "🚀 Initialisation de Terraform"
                        sh "cd ${TERRAFORM_DIR} && terraform init"

                        echo "📦 Application du plan Terraform"
                        sh "cd ${TERRAFORM_DIR} && terraform apply -auto-approve"

                        echo "🔎 Récupération de l'IP publique EC2"
                        def ip = sh(script: "cd ${TERRAFORM_DIR} && terraform output -raw public_ip", returnStdout: true).trim()

                        if (!ip || ip == "") {
                        error "❌ IP publique non récupérée. EC2 peut ne pas être disponible."
                        }

                        echo "🧾 Génération du fichier Ansible inventory.ini"
                        def inventoryContent = "[webservers]\n${ip} ansible_user=ubuntu ansible_ssh_private_key_file=${env.KEY_PATH}\n"
                        writeFile file: INVENTORY_FILE, text: inventoryContent
                        echo "📌 inventory.ini généré :\n${inventoryContent}"
                    }
                }
            }
        }

    
      

        stage('test') {
            steps {
                echo "🔍 npm audit"
                sh 'npm audit || true' // pour éviter l'échec en cas de vulnérabilité
                sh 'npm audit fix || true'

                echo "📦 Installation propre avec npm ci"
                sh 'npm ci'

                echo "🎨 Vérification du formatage et du linting"

                dir('Projet1') {
                    // Vérifie le formatage avec prettier (optionnel)
                    sh 'npm run format:check || true'

                    // Lint du projet
                    sh 'npm run lint'
                }

                dir('Projet1') {
                    echo "🧪 Lancement des tests unitaires"
                    sh 'npm run test'
                }
            }
        }






        
    }


  post {
    success {
      echo "✅ Déploiement réussi de $DOCKER_IMAGE:$DOCKER_TAG"
    }
    failure {
      echo "❌ Échec du pipeline"
    }
  }

}
