# Use the official Nginx image as the base image
FROM nginx:latest

# Install zlib library
RUN apt-get update && apt-get install -y zlib1g-dev

# Add labels for better maintainability
LABEL maintainer="amundead"
LABEL description="This Dockerfile installs Nginx with zlib library"

# Expose port 80
EXPOSE 80

# Command to start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
