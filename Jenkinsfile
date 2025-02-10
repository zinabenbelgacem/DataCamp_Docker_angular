pipeline {
    agent any
    tools { 
        jdk 'JDK8'
    }
    environment {
        // JAVA_HOME (si nécessaire)
        JAVA_HOME = 'C:/Program Files/Java/jdk1.8.0'
        // Ne pas définir DOCKER_TAG ici, car la fonction getVersion ne peut être exécutée avant le checkout.
    }
    stages {
        stage('Checkout') {
            steps {
                // Assurez-vous d'utiliser la branche correcte (ici "main")
                git branch: 'main', url: 'https://github.com/zinabenbelgacem/DataCamp_Docker_angular'
            }
        }
        stage('Set Version') {
            steps {
                script {
                    // Utilisez 'bat' pour Windows et assignez la valeur à l'environnement
                    env.DOCKER_TAG = bat(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    echo "Using DOCKER_TAG = ${env.DOCKER_TAG}"
                }
            }
        }
        stage('Docker Build') {
            steps {
                // Utilisez des chaînes en double quotes pour l'interpolation et veillez à laisser un espace avant le point (contexte de build)
                bat "docker build -t zinabenbelgacem/aston_villa:${DOCKER_TAG} ."
            }
        }
        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'mydockerhubpassword', variable: 'DockerHubPassword')]) {
                    bat "docker login -u zinabenbelgacem -p ${DockerHubPassword}"
                }
                bat "docker push zinabenbelgacem/aston_villa:${DOCKER_TAG}"
            }
        }
        stage('Deploy') {
            steps {
                sshagent(credentials: ['Vagrant_ssh']) {
                    // Vérifiez que la commande ssh est disponible dans votre PATH (par exemple, via Git for Windows)
                    bat "ssh user@192.168.42.145 \"sudo docker run aston_villa:${DOCKER_TAG}\""
                }
            }
        }
    }
}
