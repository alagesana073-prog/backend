# Use Python 3.10 slim image for a small footprint
FROM python:3.10-slim

# Install system dependencies for OCR (Tesseract and Poppler)
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    poppler-utils \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

# Copy the rest of the application
COPY . .

# Let Railway automatically manage the port
# Removed EXPOSE 5000 to prevent port routing conflicts on Railway

# Start the application using Python directly so it inherently uses os.environ.get('PORT')
# This guarantees exact matching behavior with Railway's dynamic PORT injection
CMD ["python", "api.py"]
