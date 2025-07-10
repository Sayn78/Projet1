pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'eu-west-3'  // Région AWS que tu utilises
        DOCKER_IMAGE = "sayn78300/mon-site"
        DOCKER_TAG = "1.0.0"
        INVENTORY_FILE = "inventory.ini"
        KEY_PATH = "~/.ssh/sshsenan.pem"
    }

    stages {


        stage('Checkout Code') {
            steps {
                // Cloner le dépôt GitHub dans le répertoire de travail Jenkins
                git branch: 'main', url: 'https://github.com/Sayn78/Projet1.git'  // Remplace par l'URL de ton dépôt
            }
        }

    stage('Versionning') {
        steps {
            script {
                // Récupère le dernier tag Git (ex: v1.0.3)
                def lastTag = sh(script: "git describe --tags --abbrev=0 || echo v1.0.0", returnStdout: true).trim()
                echo "🔢 Dernier tag Git : ${lastTag}"

                // Extraire et incrémenter le patch (ex: 1.0.3 → 1.0.4)
                def parts = lastTag.replace("v", "").tokenize('.')
                parts[2] = (parts[2].toInteger() + 1).toString()
                def newTag = "v${parts[0]}.${parts[1]}.${parts[2]}"
                echo "🚀 Nouveau tag Git : ${newTag}"

                // Enregistrer dans une variable d’environnement
                env.DOCKER_TAG = newTag

                // Créer le tag local et le pousser sur GitHub
                withCredentials([usernamePassword(credentialsId: 'GitHub', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh """
                    git config user.email "jenkins@local"
                    git config user.name "Jenkins"
                    git tag ${DOCKER_TAG}
                    git push https://${GIT_USER}:${GIT_TOKEN}@github.com/Sayn78/Projet1.git ${DOCKER_TAG}
                    """
                }
            }
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
                dir('www') {
                    script {
                        echo "🔍 npm audit"
                        sh 'npm audit || true' // évite l'échec en cas de vulnérabilité
                        sh 'npm audit fix || true'

                        echo "📦 Installation propre avec npm ci"
                        sh 'npm ci'

                        echo "🎨 Vérification du formatage et du linting"
                        sh 'npm run format:check || true'
                        sh 'npm run lint'

                        echo "🧪 Lancement des tests unitaires"
                        sh 'npm run test'
                    }
                }
            }
        }


        stage('Docker Build') {
            steps {
                dir('www') {
                    sh """
                        docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                        docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKER_IMAGE:latest
                    """
                }
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE:$DOCKER_TAG
                        docker push $DOCKER_IMAGE:latest
                    """
                }
            }
        }


        stage('Déploiement via Ansible') {
            steps {
                dir('Ansible') {
                    sh "ansible-playbook -i $INVENTORY_FILE deploy.yml --extra-vars \"docker_version=$DOCKER_TAG\""
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
