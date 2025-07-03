
# # Specify which base layers (default dependencies) to use
# # You may find more base layers at https://hub.docker.com/
# FROM python:3.11

# #
# # Creates directory within your Docker image
# RUN mkdir -p /app/src/
# #
# # Copies file from your Local system TO path in Docker image
# COPY main.py /app/src/
# COPY requirements.txt /app/src/
# #
# # Installs dependencies within you Docker image
# RUN pip3 install -r /app/src/requirements.txt
# #
# # Enable permission to execute anything inside the folder app
# RUN chgrp -R 65534 /app && \
#     chmod -R 777 /app


# Base image with Python
FROM python:3.11

# Install Node.js (using curl and apt)
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Python dependencies and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# (Optional) If using Node.js for frontend build, add this:
COPY package*.json ./
RUN npm install

# Copy rest of the app
COPY main.py /app/src/
COPY requirements.txt /app/src/


# Expose the Streamlit default port
EXPOSE 8501

# Run the Streamlit app
CMD ["streamlit", "run", "main.py", "--server.port=8501", "--server.enableCORS=false"]
