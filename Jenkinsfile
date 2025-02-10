pipeline {
agent any
tools{ jdk 'JDK11' }
environment {
JAVA_HOME = '/usr/lib/jvm/java-1.8.0-openjdk-amd64'
DOCKER_TAG = getVersion()
}
stages {
stage ('Clone Stage') {
steps {
git 'https://github.com/zinabenbelgacem/DataCamp_Docker_angular'
}
}
stage ('Docker Build') {
steps {
bat 'docker build -t zinabenbelgacrm/aston_villa:%DOCKER_TAG% .'
}
}
stage ('DockerHub Push') {
steps {
withCredentials([string(credentialsId: 'mydockerhubpassword', variable: 'DockerHubPassword')]) {
bat  'sudo docker login -u zinabenbelgacrm -p ${DockerHubPassword}'
}
bat  'sudo docker push zinabenbelgacrm/aston_villa:${DOCKER_TAG}'
}
}
stage ('Deploy') {
steps{
sshagent(credentials: ['Vagrant_ssh']) {
bat  "ssh user@192.168.42.145"
//sh "scp target/hello-world-app-1.0-SNAPSHOT.jar vagrant@192.168.1.201:/home/vagrant"
                    bat  "ssh user@192.168.42.145 'sudo docker run aston_villa:${DOCKER_TAG}'"
}
}
}
}
}
def getVersion() {
    def version = bat(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
    return version
}
