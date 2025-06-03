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

        stage('Run Docker Container (Local)') {
            steps {
                sh '''
                    # Stop any previous container if running
                    docker rm -f flask-app || true

                    # Run in detached mode and map port 5000
                    docker run -d --name flask-app -p 5000:5000 $DOCKER_IMAGE

                    # Optional: Wait a few seconds to make sure the app is up
                    sleep 10

                    # Optional: Check if it's reachable
                    curl -f http://localhost:5000 || echo "⚠️ Flask app not reachable!"
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
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
            echo '✅ Docker image pushed and container is running!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
        always {
            // Clean up container after job finishes
            sh "docker rm -f flask-app || true"
        }
    }
}
