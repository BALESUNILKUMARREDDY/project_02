# Use an official Python base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install OS-level dependencies (including for OpenCV)
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

# Setup YOLO model files
RUN rm -rf models && mkdir -p models && \
    wget -O models/yolov3.weights https://pjreddie.com/media/files/yolov3.weights && \
    wget -O models/yolov3.cfg https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3.cfg

# Expose the Flask default port
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
