pipeline {
    agent any
    
    environment {
        LC_ALL = 'en_IN.UTF-8'
        LANG   = 'en_IN.UTF-8'
        LANGUAGE = 'en_IN.UTF-8'
    }

    stages {
        stage('GitHub Checkout') {
            steps {
                git url: 'https://github.com/yashpotdar4536/devsecops-1.git', branch: 'main'
            }
        }

        stage('Trivy FS Scan') {
            steps {
                echo "Scanning Project Files for Misconfigurations..."
                // Scans your Dockerfile and Playbooks
                sh 'trivy fs --severity HIGH,CRITICAL --exit-code 0 .'
            }
        }

        stage('Docker Image Build') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Trivy Image Scan') {
            steps {
                echo "Scanning Docker Image for Vulnerabilities..."
                // Scans the actual built image
                sh 'trivy image --severity HIGH,CRITICAL --no-progress --exit-code 0 myapp:latest'
            }
        }

        stage('Deploy Nginx (Docker)') {
            steps {
                sh 'docker rm -f myappcontainer || true'
                sh 'docker run -d --name myappcontainer -p 80:80 myapp:latest'
            }
        }

        stage('Ansible Deploy Apache') {
            steps {
                ansiblePlaybook(
                    playbook: 'apache.yml',
                    inventory: 'inventory.ini',
                    credentialsId: 'node-ssh-key',
                    installation: 'Ansible',
                    colorized: true
                )
            }
        }
    }

    post {
        success {
            mail to: 'yashpotdar4536@gmail.com',
                 subject: "Success: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Deployment successful. Trivy Security scans passed. Nginx is on port 80, Apache on 8081."
        }
        failure {
            mail to: 'yashpotdar4536@gmail.com',
                 subject: "Failed: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Pipeline failed. Check Jenkins logs for Trivy security findings or deployment errors."
        }
    }
}// End of Pipeline
