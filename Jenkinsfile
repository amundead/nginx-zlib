pipeline {
    agent any

    environment {
        // Docker and GitHub configurations
        DOCKER_IMAGE = "nginx-zlib"               // Name of the Docker image
        DOCKERHUB_USERNAME = "amundead" // Docker Hub username
        DOCKERHUB_REPO = "${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}"
        GITHUB_USERNAME = "amundead"       // GitHub username
        GITHUB_REPO = "nginx-zlib"                 // GitHub repository name
        GITHUB_REGISTRY = "docker.pkg.github.com"
        GITHUB_REPO_URL = "${GITHUB_REGISTRY}/${GITHUB_USERNAME}/${GITHUB_REPO}"

        // Credentials for Docker Hub and GitHub Packages (stored in Jenkins)
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        GITHUB_TOKEN = credentials('github-credentials-id')
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the GitHub repository where the Dockerfile is located
                git branch: 'main', url: "https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO}.git", credentialsId: 'github-credentials-id'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image using the Dockerfile in the repository
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                // Authenticate Docker with Docker Hub using credentials stored in Jenkins
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Login to GitHub Packages') {
            steps {
                // Authenticate Docker with GitHub Packages using credentials stored in Jenkins
                script {
                    sh "echo ${GITHUB_TOKEN_PSW} | docker login ${GITHUB_REGISTRY} -u ${GITHUB_USERNAME} --password-stdin"
                }
            }
        }

        stage('Tag Docker Image for Docker Hub and GitHub Packages') {
            steps {
                // Tag the Docker image for both Docker Hub and GitHub Packages
                script {
                    sh "docker tag ${DOCKER_IMAGE}:latest ${DOCKERHUB_REPO}:latest"
                    sh "docker tag ${DOCKER_IMAGE}:latest ${GITHUB_REPO_URL}:latest"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                // Push the Docker image to Docker Hub
                script {
                    sh "docker push ${DOCKERHUB_REPO}:latest"
                }
            }
        }

        stage('Push Docker Image to GitHub Packages') {
            steps {
                // Push the Docker image to GitHub Packages
                script {
                    sh "docker push ${GITHUB_REPO_URL}:latest"
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images from local environment
            sh "docker rmi ${DOCKER_IMAGE}:latest"
            sh "docker rmi ${DOCKERHUB_REPO}:latest"
            sh "docker rmi ${GITHUB_REPO_URL}:latest"
        }
        success {
            echo 'Docker image successfully pushed to both Docker Hub and GitHub Packages!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
