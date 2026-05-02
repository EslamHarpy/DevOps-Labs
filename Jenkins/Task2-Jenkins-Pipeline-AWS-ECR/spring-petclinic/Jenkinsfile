pipeline{
    agent any 
    tools {
        maven 'maven-3.9.15'
        jdk 'jdk-17'
    }
    environment {
        AWS_ACCOUNT_ID = '053274260339' 
        AWS_DEFAULT_REGION = 'us-east-1' 
        IMAGE_REPO_NAME = 'my-spring-petclinic' 
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages{
        stage('first stage '){
            steps{
                sh 'date'
                sh 'echo hello from iti'
                sh 'whoami'
                sh 'pwd'
            }
        
        }
        stage('clone'){
            steps{
                git branch : 'main',
                url: 'https://github.com/EslamHarpy/spring-petclinic.git'
            }
        }
        stage('change config'){
            steps{
                sh 'echo server.port=8081 >> src/main/resources/application.properties'
            }
        }
        stage('compile'){
            steps{
                sh 'mvn clean compile'
            }
        }
        stage('test'){
            steps{
                sh 'mvn test'
            }
        }
        stage('package'){
            steps{
                sh 'mvn package'
            }
        }
        stage('Docker Build & Tag') {
            steps {
                script {
                    sh "docker build -t ${REPOSITORY_URI}:${IMAGE_TAG} ."
                    sh "docker tag ${REPOSITORY_URI}:${IMAGE_TAG} ${REPOSITORY_URI}:latest"
                }
            }
        }
        stage('Push to AWS ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials-id', 
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY', 
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh """
                    aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                    docker push ${REPOSITORY_URI}:${IMAGE_TAG}
                    docker push ${REPOSITORY_URI}:latest
                    """
                }
            }
        }
        stage('Run Container') {
            steps {
                script {
                    sh "docker rm -f petclinic-app || true"
                    sh "docker run -d -p 8081:8081 --name petclinic-app ${REPOSITORY_URI}:latest"
                }
            }
        }
    }   
}
