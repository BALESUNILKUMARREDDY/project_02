pipeline {
    agent any

    environment {
        FLASK_APP = 'app.py'
        TEST_REPORT = 'tests/test-results.xml'
        DOCKER_IMAGE = 'my-docker-username/my-flask-ml-app'
    }

    tools {
        python 'Python 3'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/BALESUNILKUMARREDDY/project_02.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install --upgrade pip'
                sh 'pip install -r requirements.txt'
                sh 'pip install pytest selenium'
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
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
