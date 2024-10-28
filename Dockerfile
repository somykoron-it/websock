# Use an official Python runtime based on Alpine Linux
FROM python:3.9-alpine

# Set working directory
WORKDIR /app

# Install necessary dependencies for FastAPI and Uvicorn
RUN apk add --no-cache gcc musl-dev linux-headers

# Install FastAPI and Uvicorn
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code into the container
COPY . .

# Expose port for Uvicorn
EXPOSE 8000

# Run Uvicorn with live reload for development
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
