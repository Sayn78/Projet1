pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'eu-west-3'  // Région AWS que tu utilises
        DOCKER_IMAGE = "sayn78300/mon-site"
        INVENTORY_FILE = "inventory.ini"
        KEY_PATH = "/var/lib/jenkins/.ssh/sshsenan.pem"
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
                    def lastTag = sh(script: "git describe --tags --abbrev=0 || echo 0.0.0", returnStdout: true).trim()
                    def parts = lastTag.tokenize('.')
                    def major = parts[0].toInteger()
                    def minor = parts[1].toInteger()
                    def patch = parts[2].toInteger()

                    def newTag = ""
                    def tagExists = true

                    // Boucle pour éviter conflit de tag
                    while (tagExists) {
                        patch += 1
                        newTag = "${major}.${minor}.${patch}"
                        def result = sh(script: "git tag --list ${newTag}", returnStdout: true).trim()
                        tagExists = result != ""
                    }

                    echo "🚀 Nouvelle version : ${newTag}"

                    env.DOCKER_TAG = newTag
                    currentBuild.displayName = "v${newTag}"
                    currentBuild.description = "Déploiement de la version ${newTag}"

                    sh """
                        git config user.email "jenkins@local"
                        git config user.name "Jenkins"
                        git tag ${newTag}
                    """

                    withCredentials([string(credentialsId: 'GIT_TOKEN', variable: 'GIT_TOKEN')]) {
                        sh "git push https://${GIT_TOKEN}@github.com/Sayn78/Projet1.git ${newTag}"
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
                        def keyPath = "/var/lib/jenkins/.ssh/sshsenan.pem"
                        def inventoryContent = "[webservers]\n${ip} ansible_user=ubuntu ansible_ssh_private_key_file=${keyPath}\n"
                        writeFile file: INVENTORY_FILE, text: inventoryContent
                        echo "📌 inventory.ini généré :\n${inventoryContent}"
                    }
                }
            }
        }

        stage('test') {
            steps {
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


        stage('Vérifier contenu du index.html') {
            steps {
                dir('www') {
                    sh "cat index.html"
                }
            }
        }



        stage('Docker Build') {
            steps {
                dir('www') {
                    sh 'docker builder prune -af' // Supprime tout cache de build
                    sh """
                        docker build --no-cache --build-arg CACHEBUSTER=\$(date +%s) -t $DOCKER_IMAGE:$DOCKER_TAG .
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

        stage('Setup via Ansible') {
            steps {
                dir('Ansible') {
                    sh "ansible-playbook -i $INVENTORY_FILE setup.yml --extra-vars \"docker_version=$DOCKER_TAG\""
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
