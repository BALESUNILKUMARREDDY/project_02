# Use official Python base image
FROM python:3.9-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    pkg-config \
    libgtk-3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libdc1394-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy your project files
COPY . /app

# Upgrade pip and install required python packages
RUN python3 -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Expose Flask port
EXPOSE 5000

# Command to run your app and keep container alive
CMD ["python3", "app.py"]
