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

        stage('Python Setup') {
            agent {
                docker {
                    image 'python:3.10-slim'
                    args '-u root'
                }
            }
            steps {
                sh '''#!/bin/bash
                    python3 -m venv venv
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('My SonarQube Server') {
                    sh '''#!/bin/bash
                        if ! command -v sonar-scanner &> /dev/null; then
                            echo "Installing SonarQube Scanner..."
                            wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
                            unzip sonar-scanner-cli-5.0.1.3006-linux.zip
                            export PATH=$PWD/sonar-scanner-5.0.1.3006-linux/bin:$PATH
                        fi
                        sonar-scanner
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                sh '''#!/bin/bash
                    if ! command -v kubectl &> /dev/null; then
                        echo "Installing kubectl..."
                        curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        mv kubectl /usr/local/bin/
                    fi

                    kubectl apply -f deployment/deployment.yaml
                    kubectl apply -f deployment/service.yaml
                '''
            }
        }
    }

    post {
        always {
            junit '/tests/test-results.xml'
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
