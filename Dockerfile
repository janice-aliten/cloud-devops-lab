# cloud-devops-lab — FastAPI health service container
# Build: docker build -t cloud-devops-lab .
# Run:   docker run -p 8000:8000 cloud-devops-lab

FROM python:3.11-slim

WORKDIR /app

# Create non-root runtime user for safer container execution
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Install dependencies first for layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app.py .

# Ensure non-root user owns the app directory
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
