pipeline {
    agent any
    
    environment {
        // Replace these with your Docker Hub credentials
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        DOCKER_IMAGE = 'amundead/nginx-zlib'
        DOCKER_TAG = 'latest' // You can dynamically set this as needed
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Pull code from your version control system (e.g., Git)
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using the credentials stored in Jenkins
                    sh "echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image to Docker Hub
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
        
        stage('Logout from Docker Hub') {
            steps {
                script {
                    // Logout from Docker Hub
                    sh "docker logout"
                }
            }
        }
    }

    post {
        always {
            // Cleanup any leftover Docker images from the local system
            sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
        }
    }
}
