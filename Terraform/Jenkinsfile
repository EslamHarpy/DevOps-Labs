pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = 'shopflow-app'
        AWS_ACCOUNT_ID = '200098097766'

        IMAGE_TAG = "${BUILD_NUMBER}"

        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                url: 'https://github.com/BadrEldinWael/terraform.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t shopflow ./app'
            }
        }

        stage('Configure AWS Credentials') {
    steps {
        withAWS(credentials: 'aws-creds', region: 'us-east-1') {
            sh 'aws sts get-caller-identity'
        }
    }
}

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin \
                $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Tag Image') {
            steps {
                sh '''
                docker tag shopflow:latest $ECR_URI:$IMAGE_TAG
                docker tag shopflow:latest $ECR_URI:latest
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker push $ECR_URI:$IMAGE_TAG
                docker push $ECR_URI:latest
                '''
            }
        }

        stage('Terraform Init') {
            steps {
            
                    sh 'terraform init'
                
            }
        }

        stage('Terraform Validate') {
            steps {
                
                    sh 'terraform validate'
                
            }
        }

        stage('Terraform Plan') {
            steps {
                
                    sh 'terraform plan'
            
            }
        }

        stage('Terraform Apply') {
            steps {
                
                    sh 'terraform apply -auto-approve'
                
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}