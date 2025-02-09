pipeline {
    agent any
    tools {
        jdk 'JDK11'
    }
    environment {
        JAVA_HOME = 'C:/Program Files/Java/jdk-11'  
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
                
                script {
                    def dockerBuildCmd = "docker build -t zinabenbelgacrm/aston_villa:${DOCKER_TAG} ."
                    if (isUnix()) {
                        sh dockerBuildCmd
                    } else {
                        bat dockerBuildCmd
                    }
                }
            }
        }
        stage('DockerHub Push') {
            steps {
                withCredentials([usernameColonPassword(credentialsId: '2a030e24-e16b-4dce-8e76-bd90d3da431c', variable: 'DockerHubPwd')]) {
                    script {
                        def dockerLoginCmd = "docker login -u zinabenbelgacrm -p ${DockerHubPwd}"
                        def dockerPushCmd = "docker push zinabenbelgacrm/aston_villa:${DOCKER_TAG}"

                        if (isUnix()) {
                            sh dockerLoginCmd
                            sh dockerPushCmd
                        } else {
                            bat dockerLoginCmd
                            bat dockerPushCmd
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                sshagent(credentials: ['c864780c-d467-4fd0-9448-da2fbea2a632']) {
                    script {
                        def deployCmd = "ssh vagrant@192.168.42.145 'docker run \"aston_villa:${DOCKER_TAG}\"'" // Enlever sudo si pas nécessaire
                        if (isUnix()) {
                            sh deployCmd
                        } else {
                            bat deployCmd
                        }
                    }
                }
            }
        }
    }
}

def getVersion() {
    def version = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return version.trim()  
