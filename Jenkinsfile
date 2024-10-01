pipeline {
    agent any

    environment {
        GITHUB_OWNER = 'amundead'  // Your GitHub username or organization
        GITHUB_REPOSITORY = 'nginx-zlib'  // The repository where the package will be hosted
        DOCKERHUB_REPOSITORY = 'amundead/nginx-zlib'  // Docker Hub repository
        IMAGE_NAME_GHCR = "ghcr.io/${GITHUB_OWNER}/${GITHUB_REPOSITORY}"  // Full image name for GitHub Packages
        IMAGE_NAME_DOCKERHUB = "${DOCKERHUB_REPOSITORY}"  // Full image name for Docker Hub
        TAG = 'latest'  // Tag for the Docker image
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from your repository using credentials securely
                git branch: 'main', url: "https://github.com/${GITHUB_OWNER}/${GITHUB_REPOSITORY}.git", credentialsId: 'github-credentials-id'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using docker.build with --no-cache option
                    docker.build("${IMAGE_NAME_GHCR}:${TAG}", "--no-cache .")
                }
            }
        }

        stage('Tag and Push Docker Image to GitHub Packages') {
            steps {
                script {
                    // Use docker.withRegistry for secure login and push to GitHub Packages
                    docker.withRegistry('https://ghcr.io', 'github-credentials-id') {
                        docker.image("${IMAGE_NAME_GHCR}:${TAG}").push()
                    }
                }
            }
        }

        stage('Tag and Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Use shell to manually tag the image for Docker Hub
                    sh "docker tag ${IMAGE_NAME_GHCR}:${TAG} ${IMAGE_NAME_DOCKERHUB}:${TAG}"

                    // Use docker.withRegistry for secure login and push to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image("${IMAGE_NAME_DOCKERHUB}:${TAG}").push()
                    }
                }
            }
        }

        stage('Clean up') {
            steps {
                script {
                    // Remove unused Docker images to free up space
                    sh "docker rmi ${IMAGE_NAME_GHCR}:${TAG}"
                    sh "docker rmi ${IMAGE_NAME_DOCKERHUB}:${TAG}"
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
