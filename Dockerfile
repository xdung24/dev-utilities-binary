# Step 1: Build the Nuxt project using a Node container
FROM node AS build-nuxt

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY dev-utilities/package*.json ./dev-utilities/

# Install npm packages
RUN cd dev-utilities && npm install

# Copy the rest of the application code
COPY dev-utilities/ ./dev-utilities/

# Build the Nuxt project
RUN cd dev-utilities && npm run build

# Step 2: Build the Go application using a Go container
FROM golang AS build-go

# Set the working directory
WORKDIR /app

# Copy the Go application code
COPY . .

# Copy the built Nuxt project from the previous step
COPY --from=build-nuxt /app/dev-utilities/out/ ./dev-utilities/out/

# Build the Go application binary
RUN go build -o dev-utilities-binary main.go

# Step 3: Use an Alpine container to run the Go application
FROM alpine

# Install necessary packages
RUN apk --no-cache add ca-certificates

# Copy the built Go application binary
COPY --from=build-go /app/dev-utilities-binary /app/

# Set the working directory
WORKDIR /app/

# Command to run the Go application
ENTRYPOINT ["/app/dev-utilities-binary"]