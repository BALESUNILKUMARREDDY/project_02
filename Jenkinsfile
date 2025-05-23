# Use an official Python base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

pipeline {
    agent {
        docker {
            image 'python:3.10-slim'
            args '-u root'  // runs as root to allow package installs
        }
    }

    stages {
        stage('Ensure Python Tools Are Available') {
            steps {
                sh '''
                    echo "Checking Python and pip..."

                    if ! command -v python3 &> /dev/null; then
                        echo "Python3 is not available. This image may be broken."
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
                sh '''
                    echo "Creating virtual environment..."
                    python3 -m venv venv

                    echo "Activating venv and installing dependencies..."
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }
    }
}


# Install OS-level dependencies (excluding terraform here)
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libopencv-dev \
    ffmpeg \
    wget \
    curl \
    git \
    unzip \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Add HashiCorp official repo and install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy requirements file and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the entire project into the image
COPY . .

# Ensure uploads directory exists
RUN mkdir -p static/uploads

# Download YOLO model weights if not already present
RUN mkdir -p models && \
    test -f models/yolov3.weights || \
    wget https://pjreddie.com/media/files/yolov3.weights -P models/

# Expose the Flask default port
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
