pipeline {
    agent {
        docker {
            image 'python:3.10-slim'
            args '-u root'
        }
    }

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

        stage('Ensure Python Tools Are Available') {
            steps {
                sh '''#!/bin/bash
                    echo "Checking Python and pip..."
                    
                    if ! command -v python3 &> /dev/null; then
                        echo " Python3 is not available. This image may be broken."
                        exit 1
                    fi
                    
                    if ! command -v pip3 &> /dev/null; then
                        echo "pip3 not found. Installing..."
                        apt update && apt install -y python3-pip
                    fi
                    
                    python3 --version
                    pip3 --version
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''#!/bin/bash
                    echo "Creating virtual environment..."
                    python3 -m venv venv

                    echo " Activating venv and installing dependencies..."
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pip install pytest selenium
                '''
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
                    sh '''#!/bin/bash
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_SCANNER_HOME = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv('My SonarQube Server') {
                    sh '''#!/bin/bash
                        ${SONAR_SCANNER_HOME}/bin/sonar-scanner
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''#!/bin/bash
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                sh '''#!/bin/bash
                    kubectl apply -f deployment/deployment.yaml
                    kubectl apply -f deployment/service.yaml
                '''
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
