# Use the official Poetry Docker image with Python 3.8
FROM python:3.8

# Set the working directory
WORKDIR /src

# Install system dependencies required for building Python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy only the dependency files first to leverage Docker caching
COPY pyproject.toml poetry.lock ./

# Use Poetry to install dependencies and generate requirements.txt
RUN pip install --upgrade pip \
    && pip install poetry \
    && poetry export -f requirements.txt --output requirements.txt --without-hashes \
    && pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Default command to start the application
CMD ["jupyter", "notebook", "--allow-root", "--ip=0.0.0.0", "--no-browser"]
