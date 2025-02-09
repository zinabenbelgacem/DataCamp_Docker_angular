pipeline {
    agent any
    tools { jdk 'JDK11' }
    environment {
        JAVA_HOME = 'C:/Program Files/Java/jdk-11'
    }
    stages {
        stage('Clone Stage') {
            steps {
                git branch: 'main', url: 'https://github.com/zinabenbelgacem/DataCamp_Docker_angular'
            }
        }
        stage('Set Version') {
            steps {
                script {
                    env.DOCKER_TAG = bat(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                }
            }
        }
        stage('Docker Build') {
            steps {
                bat 'docker build -t zinabenbelgacrm/aston_villa:${DOCKER_TAG} .'
            }
        }
        stage('DockerHub Push') {
            steps {
                withCredentials([usernameColonPassword(credentialsId: '2a030e24-e16b-4dce-8e76-bd90d3da431c', variable: 'DockerHubPwd')]) {
                    bat 'docker login -u zinabenbelgacrm -p ${DockerHubPwd}'
                }
                bat 'docker push zinabenbelgacrm/aston_villa:${DOCKER_TAG}'
            }
        }
        stage('Deploy') {
            steps {
                sshagent(credentials: ['c864780c-d467-4fd0-9448-da2fbea2a632']) {
                    bat '''
                        ssh vagrant@192.168.42.145 << EOF
                            sudo docker pull zinabenbelgacrm/aston_villa:${DOCKER_TAG}
                            sudo docker stop aston_villa || true
                            sudo docker rm aston_villa || true
                            sudo docker run -d --name aston_villa zinabenbelgacrm/aston_villa:${DOCKER_TAG}
                        EOF
                    '''
                }
            }
        }
    }
}
