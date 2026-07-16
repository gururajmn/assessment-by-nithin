pipeline {

    agent any

    environment {
        IMAGE_NAME = "task-tracker-app"
        CONTAINER_NAME = "task-tracker-container"
        PORT = "3000"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }


        stage('Install Dependencies') {
            steps {
                sh '''
                    node -v
                    npm -v
                    npm install
                '''
            }
        }


        stage('Test') {
            steps {
                sh '''
                    npm test
                '''
            }
        }


        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:latest .
                '''
            }
        }


        stage('Stop Existing Container') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                '''
            }
        }


        stage('Deploy Container') {
            steps {
                sh '''
                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${PORT}:3000 \
                    ${IMAGE_NAME}:latest
                '''
            }
        }


        stage('Verify Deployment') {
            steps {
                sh '''
                    sleep 5
                    docker ps
                    curl http://localhost:${PORT}
                '''
            }
        }
    }


    post {

        success {
            echo 'Application deployed successfully 🚀'
        }

        failure {
            echo 'Deployment failed ❌'
        }

        always {
            echo 'Pipeline completed'
        }
    }
}
