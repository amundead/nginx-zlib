pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials') // Jenkins credential ID for Docker Hub
        IMAGE_NAME = 'your-dockerhub-username/your-image-name'
        TAG = 'latest'  // or set a specific tag
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from your repository
                git branch: 'main', url: 'https://github.com/your-repo-url.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        // Push the Docker image to Docker Hub
                        docker.image("${IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }

        stage('Clean up') {
            steps {
                script {
                    // Remove unused Docker images to free up space
                    sh "docker rmi ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after the pipeline
            cleanWs()
        }
    }
}
