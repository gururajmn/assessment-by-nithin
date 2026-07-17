pipeline {

    agent any

    environment {
        IMAGE_NAME = "task-tracker-app"
        CONTAINER_NAME = "task-tracker-container"
        IMAGE_TAG = "${BUILD_NUMBER}"
        PORT = "3000"
    }

    stages {

        stage('SCM Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    echo "Installing dependencies..."

                    node -v
                    npm -v

                    npm install
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    echo "Running tests..."

                    npm test
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."

                    docker build \
                    -t ${IMAGE_NAME}:${IMAGE_TAG} \
                    -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Stop Old Container') {
            steps {
                sh '''
                    echo "Removing old container if exists..."

                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true

                    docker compose down || true
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
                    echo "Deploying application..."

                    docker compose up -d --build
                '''
            }
        }

        stage('Wait For Application') {
            steps {
                sh '''
                    echo "Waiting for application..."

                    i=1

                    while [ $i -le 30 ]
                    do

                        if docker exec ${CONTAINER_NAME} wget -qO- http://localhost:3000/health > /dev/null 2>&1
                        then
                            echo "Application Started Successfully"
                            exit 0
                        fi

                        echo "Attempt $i/30"

                        sleep 5

                        i=$((i+1))

                    done

                    echo "Application failed to start"

                    docker logs ${CONTAINER_NAME}

                    exit 1
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    echo "==========================="
                    echo "HOME PAGE"
                    echo "==========================="

                    docker exec ${CONTAINER_NAME} \
                    wget -qO- http://localhost:3000/

                    echo ""

                    echo "==========================="
                    echo "HEALTH ENDPOINT"
                    echo "==========================="

                    docker exec ${CONTAINER_NAME} \
                    wget -qO- http://localhost:3000/health

                    echo ""

                    echo "==========================="
                    echo "TASKS API"
                    echo "==========================="

                    docker exec ${CONTAINER_NAME} \
                    wget -qO- http://localhost:3000/api/tasks

                    echo ""

                    echo "Deployment Verified Successfully"
                '''
            }
        }

    }

    post {

        success {

            echo "======================================"
            echo "BUILD SUCCESSFUL"
            echo "Application deployed successfully"
            echo "======================================"

            sh '''
                docker ps
            '''
        }

        failure {

            echo "======================================"
            echo "BUILD FAILED"
            echo "Container Logs"
            echo "======================================"

            sh '''
                docker ps -a

                docker logs ${CONTAINER_NAME} || true
            '''
        }

        always {

            echo "Cleaning unused Docker images..."

            sh '''
                docker image prune -f || true
            '''
        }
    }
}
