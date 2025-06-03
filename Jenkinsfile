pipeline {
    agent any

    environment {
        FLASK_APP = 'app.py'
        DOCKER_IMAGE = 'balesunil/my-flask-ml-app:latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/BALESUNILKUMARREDDY/project_02.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials', // Replace with your actual credentials ID
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh """
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push $DOCKER_IMAGE
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Docker image pushed successfully!'
            // slackSend(channel: '#build-alerts', message: "✅ Docker Push Successful: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
        }
        failure {
            echo '❌ Pipeline failed.'
            // slackSend(channel: '#build-alerts', message: "❌ Docker Push Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
        }
    }
}
