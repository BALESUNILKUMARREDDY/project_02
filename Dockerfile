# Use an official Python base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install OS-level dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libopencv-dev \
    ffmpeg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy requirement files
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy application code
COPY . .

# Create upload folder if not exists
RUN mkdir -p static/uploads

# Copy YOLO and ML model files to proper location (update paths if needed)
# Assumes models are stored in /app/models
RUN test -f models/yolov3.weights || wget https://pjreddie.com/media/files/yolov3.weights -P models/

# Expose port for Flask
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
