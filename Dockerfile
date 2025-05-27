# Use an official Python base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    pkg-config \
    libjpeg-dev \
    libtiff-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies early to avoid cache busting
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Build OpenCV from source with contrib modules (v4.5.5)
WORKDIR /opt
RUN git clone --branch 4.5.5 https://github.com/opencv/opencv.git && \
    git clone --branch 4.5.5 https://github.com/opencv/opencv_contrib.git && \
    mkdir -p opencv/build && cd opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
          -D BUILD_EXAMPLES=OFF .. && \
    make -j$(nproc) && make install && ldconfig

# Set working directory
WORKDIR /app

# Copy app files
COPY . .

# Ensure uploads directory exists
RUN mkdir -p static/uploads

# Setup YOLO model files
RUN rm -rf models && mkdir -p models && \
    wget -O models/yolov3.weights https://pjreddie.com/media/files/yolov3.weights && \
    wget -O models/yolov3.cfg https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3.cfg

# Expose Flask port
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
