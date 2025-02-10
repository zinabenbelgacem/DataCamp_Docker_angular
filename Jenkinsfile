pipeline {
    agent any
    tools { 
        jdk 'JDK11' // Ensure JDK is installed and configured on Jenkins
    }
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64' // Correct path for Linux environment
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
            def gitCommit = bat(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
            gitCommit = gitCommit.replaceAll("\r", "").replaceAll("\n", "")
            env.DOCKER_TAG = gitCommit
            echo "DOCKER_TAG = ${env.DOCKER_TAG}"
        }
    }
}
stage('Docker Build') {
    steps {
        script {
            def tag = env.DOCKER_TAG
            echo "Building Docker image with tag: ${tag}"
            bat 'docker build -t "zinabenbelgacem/aston_villa" .'
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


        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'mydockerhubpassword', variable: 'DockerHubPassword')]) {
                    sh "echo ${DockerHubPassword} | docker login -u zinabenbelgacem --password-stdin" // Use sh for Linux
                }
                sh "docker push zinabenbelgacem/aston_villa:${env.DOCKER_TAG}" // Use sh for Linux
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['Vagrant_ssh']) {
                    sh """
                    ssh vagrant@192.168.42.145 "sudo docker pull zinabenbelgacem/aston_villa:${env.DOCKER_TAG} && sudo docker run -d --name aston_villa_${env.DOCKER_TAG} zinabenbelgacem/aston_villa:${env.DOCKER_TAG}"
                    """
                }
            }
        }
    }
}
