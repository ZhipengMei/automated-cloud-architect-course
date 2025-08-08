# ---- Builder Stage ----
# Use a full-featured image to install dependencies
FROM python:3.9-slim as builder

WORKDIR /app

# Copy requirements and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# ---- Runner Stage ----
# Use a minimal, secure base image
FROM python:3.9-slim

WORKDIR /app

# Copy the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# Copy the application code from the builder stage
COPY --from=builder /app .

# Run the application
CMD ["python", "./app.py"]