FROM python:3.10-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first (for Docker layer caching)
COPY requirements.txt .

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy all app files
COPY . .

# Create required folders
RUN mkdir -p static/generated templates instances uploads

# Expose port 10000 (Render default)
EXPOSE 10000

# Start the app — longer timeout for music generation (up to 3 min)
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "--timeout", "180", "--workers", "1", "app:app"]
