#!/bin/bash

# This script starts the Docker container defined in docker-compose.yml

echo "Starting the Docker container using Docker Compose..."

# Navigate to the directory containing the docker-compose.yml file if it's not in the current directory
# cd /path/to/your/docker-compose/file

# Run docker-compose up in detached mode (-d) or foreground mode
docker-compose up -d # Use -d to run in the background
# docker-compose up # Use this to run in the foreground and see logs

echo "Docker Compose command finished."
echo "Check 'docker ps' to see if the container is running."
echo "If running in detached mode (-d), use 'docker-compose logs' to view container output."
