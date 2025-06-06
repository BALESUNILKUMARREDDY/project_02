pipeline {
    agent any

    environment {
        FLASK_APP = 'app.py'
        DOCKER_IMAGE = 'balesunilkumarreddy6321/my-flask-ml-app:latest'
        REPO_PATH = '/home/ubuntu/app/project_02'
    }

    stages {
        // Removed Clone stage since repo is already cloned

        stage('Build Docker Image') {
            steps {
                sh """
                    sudo su - ubuntu -c '
                        cd $REPO_PATH
                        docker build -t $DOCKER_IMAGE .
                    '
                """
            }
        }

        stage('Run Docker Container (Local)') {
            steps {
                sh """
                    sudo su - ubuntu -c '
                        docker rm -f flask-app || true
                        docker run -d --name flask-app -p 5000:5000 $DOCKER_IMAGE
                        sleep 10
                        curl -f http://localhost:5000 || echo "⚠️ Flask app not reachable!"
                    '
                """
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
                        sudo su - ubuntu -c '
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker push $DOCKER_IMAGE
                        '
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    sudo su - 
                        cd /root
                        kubectl apply -f lok.yaml
                        kubectl rollout status deployment/flask-deployment
                    '
                """
            }
        }
    }

    post {
        success {
            echo '✅ Docker image pushed and deployed to Kubernetes!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
        always {
            sh "sudo su - ubuntu -c 'docker rm -f flask-app || true'"
        }
    }
}
