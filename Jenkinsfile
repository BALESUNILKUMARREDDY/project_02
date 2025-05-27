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

        stage('Run Docker Container') {
            steps {
                sh "docker run -d -p 5000:5000 $DOCKER_IMAGE"
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully!'
            // slackSend(channel: '#build-alerts', message: "✅ Build Successful: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
        }
        failure {
            echo '❌ Pipeline failed.'
            // slackSend(channel: '#build-alerts', message: "❌ Build Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
        }
    }
}
