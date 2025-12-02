# Docker Deployment Guide

## Overview

This guide provides instructions for deploying the AINA RAG platform using Docker. This method is ideal for local development, testing, or deployment on any server with Docker installed.

---

## Prerequisites

### Install Docker

Before proceeding, ensure Docker is installed and running on your system.

#### Installation Guides by Operating System:

- **Linux**: [Install Docker Engine on Linux](https://docs.docker.com/engine/install/)
- **macOS**: [Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)
- **Windows**: [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)

#### Verify Docker Installation

After installation, verify Docker is working correctly:

```bash
docker --version
docker run hello-world
```

#### Install Docker Compose (if not included)

Docker Compose is typically included with Docker Desktop. For Linux, you may need to install it separately:

- [Install Docker Compose](https://docs.docker.com/compose/install/)

Verify installation:

```bash
docker compose version
```

---

## Deployment Steps

### Step 1: Clone the Repositories

Clone both the frontend and backend repositories:

```bash
# Clone the backend repository
git clone https://github.com/CLOUDLAB-URV/aina-backend.git
cd aina-backend

# Clone the frontend repository (in a separate directory)
cd ..
git clone https://github.com/CLOUDLAB-URV/aina-frontend.git
```

### Step 2: Build Docker Images

Build the Docker images for both the backend and frontend applications.

#### Build Backend Image

```bash
cd aina-backend
docker build -t aina-backend:latest .
```

#### Build Frontend Image

```bash
cd ../aina-frontend
docker build -t aina-frontend:latest .
```

**Note**: Building the images may take several minutes depending on your internet connection and system performance.

#### Verify Images

Check that the images were built successfully:

```bash
docker images | grep aina
```

You should see both `aina-backend` and `aina-frontend` listed.

---

## Running the Application

You can run the application using either **Docker Compose** or **individual Docker commands**.

### Option 1: Using Docker Compose

Docker Compose simplifies running multi-container applications and manages networking between containers automatically.

#### 1. Create a Docker Compose File

Create a file named `docker-compose.yml` in a new directory:

```bash
mkdir aina-deployment
cd aina-deployment
```

Create the `docker-compose.yml` file with the following content:

```yaml
services:
  backend:
    image: aina-backend:latest
    container_name: aina-backend
    ports:
      - "8000:8000"
    restart: always

  frontend:
    image: aina-frontend:latest
    container_name: aina-frontend
    ports:
      - "5173:5173"
    depends_on:
      - backend
    environment:
      VITE_API_URL: "http://backend:8000"
    restart: always
```

#### 2. Start the Application

Run the following command in the directory containing `docker-compose.yml`:

```bash
docker compose up -d
```

The `-d` flag runs the containers in detached mode (background).

#### 3. Verify Containers Are Running

```bash
docker compose ps
```

You should see both containers running.

#### 4. View Logs

To view logs from both containers:

```bash
docker compose logs -f
```

To view logs from a specific service:

```bash
docker compose logs -f backend
docker compose logs -f frontend
```

Press `Ctrl+C` to exit the log view.

---

### Option 2: Using Individual Docker Commands

If you prefer not to use Docker Compose, you can run the containers individually.

#### 1. Create a Docker Network

First, create a network so the containers can communicate:

```bash
docker network create aina-network
```

#### 2. Run the Backend Container

```bash
docker run -d \
  --name aina-backend \
  --network aina-network \
  -p 8000:8000 \
  --restart always \
  aina-backend:latest
```

#### 3. Run the Frontend Container

```bash
docker run -d \
  --name aina-frontend \
  --network aina-network \
  -p 5173:5173 \
  -e VITE_API_URL="http://backend:8000" \
  --restart always \
  aina-frontend:latest
```

#### 4. Verify Containers Are Running

```bash
docker ps
```

You should see both `aina-backend` and `aina-frontend` containers running.

---

## Accessing the Application

Once the containers are running:

1. **Frontend**: Open your browser and navigate to:
   ```
   http://localhost:5173
   ```

2. **Backend API**: The API is accessible at:
   ```
   http://localhost:8000
   ```

3. **Login**: Use one of the following default usernames with their respective passwords:
   - `admin` - Full administrative access
   - `agentcreator` - Can create and manage agents
   - `chatuser` - Can chat with agents

**Note**: If the default passwords were configured during the Docker image build, use those credentials. Otherwise, refer to the application documentation for default credentials.

---

## Managing the Deployment

### Using Docker Compose

#### Stop the Application
```bash
docker compose down
```

#### Restart the Application
```bash
docker compose restart
```

#### Stop a Specific Service
```bash
docker compose stop backend
docker compose stop frontend
```

#### Start a Specific Service
```bash
docker compose start backend
docker compose start frontend
```

#### Rebuild and Restart (after code changes)
```bash
# Rebuild images
cd aina-backend
docker build -t aina-backend:latest .
cd ../aina-frontend
docker build -t aina-backend:latest .

# Restart services
cd ../aina-deployment
docker compose down
docker compose up -d
```

---

### Using Individual Docker Commands

#### Stop Containers
```bash
docker stop aina-backend aina-frontend
```

#### Start Containers
```bash
docker start aina-backend aina-frontend
```

#### Restart Containers
```bash
docker restart aina-backend aina-frontend
```

#### Remove Containers
```bash
docker rm -f aina-backend aina-frontend
```

#### View Logs
```bash
docker logs -f aina-backend
docker logs -f aina-frontend
```

---

## Using Pre-built Images from Docker Hub

If the images are available on Docker Hub, you can skip building and use them directly:

### Update docker-compose.yml

```yaml
services:
  backend:
    image: stepii/aina-backend:latest
    container_name: aina-backend
    ports:
      - "8000:8000"
    restart: always

  frontend:
    image: stepii/aina-frontend:latest
    container_name: aina-frontend
    ports:
      - "5173:5173"
    depends_on:
      - backend
    environment:
      VITE_API_URL: "http://backend:8000"
    restart: always
```

### Pull and Run

```bash
docker compose pull
docker compose up -d
```

---

## Troubleshooting

### Port Already in Use

If you see an error about ports already being in use, you can either:

1. **Stop the conflicting service** using that port
2. **Change the port mapping** in the docker-compose.yml or docker run command:
   ```yaml
   ports:
     - "8001:8000"  # Maps host port 8001 to container port 8000
   ```

### Container Fails to Start

Check the logs for errors:

```bash
# With Docker Compose
docker compose logs backend
docker compose logs frontend

# With individual commands
docker logs aina-backend
docker logs aina-frontend
```

### Cannot Access Frontend

1. Verify the container is running: `docker ps`
2. Check if the port is correctly mapped: `docker port aina-frontend`
3. Ensure no firewall is blocking port 5173
4. Try accessing using `http://127.0.0.1:5173` instead of `localhost`

### Backend Connection Issues

1. Verify the backend container is running: `docker ps`
2. Check backend logs: `docker logs aina-backend`
3. Test the backend API directly: `curl http://localhost:8000/health` (if health endpoint exists)
4. Ensure the `VITE_API_URL` environment variable is correctly set in the frontend

### Network Issues Between Containers

If using individual Docker commands and containers can't communicate:

1. Verify both containers are on the same network:
   ```bash
   docker network inspect aina-network
   ```
2. Ensure the network was created before starting containers
3. Use container names (not `localhost`) in the API URL

---

## Cleaning Up

To completely remove the application and free up disk space:

### Remove Containers
```bash
# With Docker Compose
docker compose down

# With individual commands
docker rm -f aina-backend aina-frontend
```

### Remove Images
```bash
docker rmi aina-backend:latest aina-frontend:latest
```

### Remove Network (if created manually)
```bash
docker network rm aina-network
```

### Remove Volumes (if any)
```bash
docker volume prune
```
