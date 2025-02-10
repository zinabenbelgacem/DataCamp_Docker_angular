pipeline {
    agent any
    tools { 
        jdk 'JDK11'
    }
    environment {
        JAVA_HOME = 'C:/Program Files/Java/jdk-11'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/zinabenbelgacem/DataCamp_Docker_angular'
            }
        }

        stage('Set Version') {
            steps {
                script {
                    // Capture la sortie de la commande et la stocke proprement
                    def gitCommit = bat(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    env.DOCKER_TAG = gitCommit
                    echo "DOCKER_TAG = ${env.DOCKER_TAG}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    def tag = env.DOCKER_TAG
                    bat "docker build -t zinabenbelgacem/aston_villa:${tag} ."
                }
            }
        }

        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'mydockerhubpassword', variable: 'DockerHubPassword')]) {
                    bat "echo ${DockerHubPassword} | docker login -u zinabenbelgacem --password-stdin"
                }
                bat "docker push zinabenbelgacem/aston_villa:${env.DOCKER_TAG}"
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['Vagrant_ssh']) {
                    bat """
                        ssh user@192.168.42.145 "sudo docker pull zinabenbelgacem/aston_villa:${env.DOCKER_TAG} && sudo docker run -d --name aston_villa_${env.DOCKER_TAG} zinabenbelgacem/aston_villa:${env.DOCKER_TAG}"
                    """
                }
            }
        }
    }
}
