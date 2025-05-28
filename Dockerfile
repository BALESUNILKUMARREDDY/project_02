FROM python:3.10-slim

# Environment setup
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install OpenCV and other system dependencies
RUN apt update && apt install -y --no-install-recommends \
    python3-opencv \
    libopencv-dev \
    ffmpeg \
    wget \
    curl \
    git \
    unzip \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Optional: pip-based OpenCV for Python-specific features
RUN pip install --no-cache-dir opencv-python opencv-contrib-python

# Set working directory
WORKDIR /app

# Copy codebase
COPY . .

# Ensure uploads folder exists
RUN mkdir -p static/uploads

# Download YOLO model files
RUN rm -rf models && mkdir -p models && \
    wget -O models/yolov3.weights https://pjreddie.com/media/files/yolov3.weights && \
    wget -O models/yolov3.cfg https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3.cfg

# Expose Flask port
EXPOSE 5000

# Start the Flask application
CMD ["python", "app.py"]  
