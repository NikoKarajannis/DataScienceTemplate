#sh commands to build and run container:
#Build the Docker image
#docker build -t datascience-template .
# Run the Docker container
# docker run -p 8888:8888 datascience-template

# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Install Git and other dependencies
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Sphinx
RUN pip install sphinx

# Copy the rest of the application code into the container
COPY . .

# Initialize Sphinx documentation if not already done
RUN if [ ! -d "docs" ]; then \
    sphinx-quickstart -q -p "Your Project" -a "Your Name" -v "0.1" --sep --ext-autodoc --ext-doctest --ext-intersphinx --ext-viewcode --makefile --batchfile docs; \
    fi

# Install pre-commit and set up the hooks
RUN pip install pre-commit && \
    pre-commit install --install-hooks

# Run pre-commit hooks on all files
RUN pre-commit run --all-files || true

# Build the Sphinx documentation
RUN make -C docs html

# Expose port 8888 for Jupyter Notebook
EXPOSE 8888

# Run the Jupyter Notebook server
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
