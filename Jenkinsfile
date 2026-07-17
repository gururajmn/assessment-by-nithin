pipeline {

    agent any

    environment {

        IMAGE_NAME = "task-tracker-app"
        CONTAINER_NAME = "task-tracker-container"
        PORT = "3000"
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                    echo "Installing Node dependencies"

                    node -v
                    npm -v

                    npm install
                '''
            }
        }


        stage('Run Tests') {
            steps {
                sh '''
                    echo "Running application tests"

                    npm test
                '''
            }
        }


        stage('Docker Build') {

            steps {

                sh '''
                    echo "Building Docker image"

                    docker build \
                    -t ${IMAGE_NAME}:${IMAGE_TAG} \
                    -t ${IMAGE_NAME}:latest .
                '''
            }
        }



        stage('Deploy Using Docker Compose') {

            steps {

                sh '''
		    docker stop task-tracker-container || true

                    docker rm task-tracker-container || true

                    echo "Stopping previous deployment"

                    docker compose down || true


                    echo "Starting application"

                    docker compose up -d --build

                '''
            }
        }



        stage('Wait For Application') {

            steps {

                sh '''

                echo "Waiting for application readiness"


                for i in {1..30}
                do

                    if curl -f http://localhost:${PORT}/health
                    then

                        echo "Application is ready"
                        exit 0

                    fi


                    echo "Waiting..."
                    sleep 5

                done


                echo "Application failed to start"

                exit 1

                '''
            }
        }



        stage('Verify Deployment') {

            steps {

                sh '''

                    echo "Checking application endpoints"


                    echo "Home Endpoint"

                    curl http://localhost:${PORT}/


                    echo "Health Endpoint"

                    curl http://localhost:${PORT}/health


                    echo "Tasks API Endpoint"

                    curl http://localhost:${PORT}/api/tasks


                    echo "Deployment successful"

                '''
            }
        }


    }



    post {


        success {

            echo "================================="
            echo "BUILD SUCCESSFUL"
            echo "Application deployed successfully"
            echo "================================="

        }



        failure {

            echo "================================="
            echo "BUILD FAILED"
            echo "Cleaning resources"
            echo "================================="


            sh '''

            docker compose down || true

            '''

        }



        always {

            echo "Cleaning unused Docker resources"


            sh '''

            docker image prune -f || true

            '''

        }

    }

}
