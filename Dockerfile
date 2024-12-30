#sh commands to build and run container:
#Build the Docker image
#docker build -t datascience-template .
# Run the Docker container
# docker run -p 8888:8888 datascience-template

# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Sphinx
RUN pip install sphinx

# Initialize Sphinx documentation
RUN sphinx-quickstart -q -p "Your Project" -a "Your Name" -v "0.1" --sep -t .sphinx_template --ext-autodoc --ext-doctest --ext-intersphinx --ext-viewcode --makefile --batchfile docs

# Install pre-commit and set up the hooks
RUN pip install pre-commit && \
    pre-commit install --install-hooks && \
    pre-commit run --all-files

# Copy the rest of the application code into the container
COPY . .

# Expose port 8888 for Jupyter Notebook
EXPOSE 8888

# Run the Jupyter Notebook server
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
