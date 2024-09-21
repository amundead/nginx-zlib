pipeline {
    agent any

    environment {
        // Docker Hub credentials (stored in Jenkins Credentials Manager)
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        DOCKER_IMAGE = "amundead/nginx-zlib"
        GITHUB_CREDENTIALS = credentials('github-credentials-id')
//GITHUB_REPO = "git@github.com:amundead/nginx-zlib.git"
        GITHUB_REPO = "https://github.com/amundead/nginx-zlib.git"
        BRANCH = "main"  // The branch to push to GitHub
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository from GitHub
                git branch: "${BRANCH}", url: "${GITHUB_REPO}", credentialsId: "${GITHUB_CREDENTIALS}"
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

        stage('Docker Login') {
            steps {
                // Login to Docker Hub
                script {
                    sh "echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                // Tag and push the Docker image to Docker Hub
                script {
                    sh "docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:latest"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                // Push any changes made to the repository back to GitHub
                script {
                    sh """
                    git config user.name "test"
                    git config user.email "test@yahoo.com"
                    git add .
                    git commit -m "Automated Docker image build and push by Jenkins"
                    git push origin ${BRANCH}
                    """
                }
            }
        }
    }

    post {
        always {
            // Cleanup the Docker images after the build
            sh "docker rmi ${DOCKER_IMAGE}:latest"
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
