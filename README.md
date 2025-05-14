# Flask ML App

This is a sample Flask-based machine learning application integrated with a DevOps pipeline using Jenkins, Docker, Kubernetes, SonarQube, Pytest, and Selenium.

## Features
- Flask web application
- TensorFlow & Keras for machine learning
- CI/CD with Jenkins
- Docker containerization
- Kubernetes deployment
- Code analysis with SonarQube
- Unit testing with Pytest
- End-to-end testing with Selenium

## Project Structure
```
my-flask-ml-app/
├── app.py
├── requirements.txt
├── Dockerfile
├── Jenkinsfile
├── tests/
│   └── test_app.py
├── deployment/
│   ├── deployment.yaml
│   └── service.yaml
├── sonar-project.properties
├── .gitignore
└── README.md
```

## How to Run
```bash
pip install -r requirements.txt
python app.py
```

## Run Tests
```bash
pytest
```