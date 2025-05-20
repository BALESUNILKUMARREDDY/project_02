pipeline {
    agent any

    environment {
        FLASK_APP = 'app.py'
        TEST_REPORT = 'tests/test-results.xml'
        DOCKER_IMAGE = 'balesunil/my-flask-ml-app:latest'
        TF_VAR_cluster_name = 'flask-ml-cluster'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/BALESUNILKUMARREDDY/project_02.git'
            }
        }
        stage('Install Python and Dependencies') {
            steps {
                sh '''
                    #!/bin/bash

                    echo "Checking Python installation..."
                    if ! command -v python3 &> /dev/null; then
                        echo " Python3 not found. Installing..."
                        sudo apt update && sudo apt install -y python3 python3-venv python3-pip
                    else
                        echo "Python3 is already installed."
                    fi

                    echo "Setting up virtual environment..."
                    python3 -m venv venv
                    source venv/bin/activate

                    echo "Upgarding pip and installing dependencies..."
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pip install pytest selenium
                '''
            }
        }

        stage('Run Unit Tests (Pytest)') {
            steps {
                sh 'pytest tests/test_app.py --junitxml=$TEST_REPORT'
            }
        }

        stage('Run UI Tests (Selenium)') {
            steps {
                sh 'pytest tests/test_selenium.py'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_SCANNER_HOME = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv('My SonarQube Server') {
                    sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner"
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                sh 'kubectl apply -f deployment/deployment.yaml'
                sh 'kubectl apply -f deployment/service.yaml'
            }
        }
    }

    post {
        always {
            junit '**/tests/test-results.xml'
        }
        success {
            echo '✅ Pipeline executed successfully!'
            slackSend(channel: '#build-alerts', message: "✅ Build Successful: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
        }
        failure {
            echo '❌ Pipeline failed.'
            slackSend(channel: '#build-alerts', message: "❌ Build Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
        }
    }
}
