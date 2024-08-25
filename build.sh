#!/bin/bash

# Step 1: Check out the latest code of the submodule dev-utilities
git submodule update --init --recursive
git submodule update --remote dev-utilities

# Step 2: Navigate to the dev-utilities directory
cd dev-utilities

# Step 3: Install npm packages
npm install

# Step 4: Run npm build to generate static files in the out folder
npm run build

# Step 5: Navigate back to the root directory
cd ..

# Step 6: Build the Go application
go build -o dev-utilities-binary main.go

echo "Build completed successfully."