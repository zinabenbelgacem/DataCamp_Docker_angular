pipeline {
agent any
tools{ jdk 'JDK8' }
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
sh 'docker build -t zinabenbelgacrm/aston_villa:${DOCKER_TAG}.'
}
}
stage ('DockerHub Push') {
steps {
withCredentials([string(credentialsId: 'mydockerhubpassword', variable: 'DockerHubPassword')]) {
sh 'sudo docker login -u zinabenbelgacrm -p ${DockerHubPassword}'
}
sh 'sudo docker push zinabenbelgacrm/aston_villa:${DOCKER_TAG}'
}
}
stage ('Deploy') {
steps{
sshagent(credentials: ['Vagrant_ssh']) {
sh "ssh user@Ip_Recette"
//sh "scp target/hello-world-app-1.0-SNAPSHOT.jar vagrant@192.168.1.201:/home/vagrant"
sh "ssh user@Ip_Recette ‘sudo docker run “image_name:${DOCKER_TAG}"’”
}
}
}
}
}
def getVersion(){
def version = sh returnStdout: true, script: 'git rev-parse --short HEAD'
return version
}