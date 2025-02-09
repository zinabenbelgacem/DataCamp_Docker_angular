pipeline {
    agent any
    tools {
        jdk 'JDK11'  // Remplacer 'JDK8' par 'JDK11'
    }
    environment {
        JAVA_HOME = 'C:/Program Files/Java/jdk-11 ' 
        DOCKER_TAG = getVersion()
    }
    stages {
        stage('Clone Stage') {
            steps {
                git 'https://gitlab.com/jmlhmd/datacamp_docker_angular.git'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t zinabenbelgacrm/aston_villa:${DOCKER_TAG} .'
            }
        }
        stage('DockerHub Push') {
            steps {
                withCredentials([usernameColonPassword(credentialsId: '2a030e24-e16b-4dce-8e76-bd90d3da431c', variable: 'DockerHubPwd')]) {
                    sh 'sudo docker login -u zinabenbelgacrm -p ${DockerHubPwd}'
                }
                sh 'sudo docker push zinabenbelgacrm/aston_villa:${DOCKER_TAG}'
            }
        }
        stage('Deploy') {
            steps {
                sshagent(credentials: ['c864780c-d467-4fd0-9448-da2fbea2a632']) {
                    sh "ssh vagrant@192.168.42.145 'sudo docker run \"aston_villa:${DOCKER_TAG}\"'"
                }
            }
        }
    }
}

def getVersion() {
    def version = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return version
}
