FROM python:3.10-slim

# Install dependencies sistem jika diperlukan
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependensi Python yang dibutuhkan script
RUN pip install --no-cache-dir curl_cffi

# Copy seluruh isi proyek ke container
COPY . .

# Jalankan skrip Python
CMD ["python", "zturbo_v3.py"]
