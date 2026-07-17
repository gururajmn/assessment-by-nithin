# Assessment by Nithin

## Task Tracker Application

### Objective

Build a complete DevOps CI/CD pipeline for the Task Tracker Node.js application using Docker, Docker Compose, and Jenkins.

## Requirements

### Docker

- Multi-stage Docker build
- Minimal base image (Alpine)
- Run application as a non-root user

### Docker Compose

- Create a docker-compose.yml file
- Application should start using:

```bash
docker compose up -d
```

### Jenkins Pipeline

Pipeline stages:

- Checkout Source Code
- Install Dependencies
- Run Tests
- Build Docker Image
- Deploy using Docker Compose
- Verify deployment using curl

### Endpoints

- http://localhost:3000/
- http://localhost:3000/health
- http://localhost:3000/api/tasks

## Technologies

- Node.js
- Express.js
- Docker
- Docker Compose
- Jenkins

## Run Locally

```bash
npm install
npm start
```

## Run with Docker

```bash
docker build -t task-tracker-app .
docker run -d -p 3000:3000 task-tracker-app
```

## Run with Docker Compose

```bash
docker compose up -d
```
