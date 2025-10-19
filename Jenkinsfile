pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-id')
        IMAGE_NAME = "jay16nair/blue-green-demo"
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Build & Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker build -t ${IMAGE_NAME}:blue --build-arg VERSION=Blue ."
                        sh "docker build -t ${IMAGE_NAME}:green --build-arg VERSION=Green ."
                        sh "docker push ${IMAGE_NAME}:blue"
                        sh "docker push ${IMAGE_NAME}:green"
                    }
                }
            }
        }

        stage('Deploy Blue') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG')]) {
                    sh "kubectl apply -f k8s-blue.yaml"
                }
            }
        }

        stage('Deploy Green') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG')]) {
                    sh "kubectl apply -f k8s-green.yaml"
                }
            }
        }

        stage('Switch Traffic to Green') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG')]) {
                    sh "kubectl patch service demo-service -p '{\"spec\":{\"selector\":{\"app\":\"demo\",\"version\":\"green\"}}}'"
                }
            }
        }
    }
}
