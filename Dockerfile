# ----------- Builder stage -----------
FROM python:3.11-slim as builder

# Set build environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install build dependencies (if any needed, e.g., for pip installs with wheels)
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies separately to maximize layer caching
COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip wheel --wheel-dir /wheels -r requirements.txt

# ----------- Runtime stage -----------
FROM python:3.11-slim as runtime

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Copy pre-installed wheels and install them
COPY --from=builder /wheels /wheels
COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --find-links=/wheels -r requirements.txt && \
    rm -rf /wheels

# Copy application code
COPY . .

# Expose port (adjust if your app runs on a different port)
EXPOSE 8000

# Start the app using uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
