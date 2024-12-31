#sh commands to build and run container:
#Build the Docker image
#docker build -t datascience-template .
# Run the Docker container
# docker run -p 8888:8888 datascience-template

# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Install Git and other dependencies
RUN apt-get update && \
    apt-get install -y git make curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install development tools
RUN pip install --no-cache-dir \
    jupyter \
    ipykernel \
    black \
    flake8 \
    pytest \
    streamlit

# Expose port 8888 for Jupyter Notebook
EXPOSE 8888 8501

# Run the Jupyter Notebook server
CMD ["tail", "-f", "/dev/null"]