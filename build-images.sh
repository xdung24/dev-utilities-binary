#!/bin/bash

# Variables
DOCKER_USERNAME="xdung24"
IMAGE_NAME="dev-utilities"
IMAGE_TAG="latest"

# Step 1: Log in to Docker Hub
docker login

# Step 2: Build the Docker image
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG .

# Step 3: Push the Docker image to Docker Hub
docker push $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG

echo "Docker image pushed to Docker Hub successfully."