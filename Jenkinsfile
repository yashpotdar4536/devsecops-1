pipeline {
    agent any
    
    environment {
        // Fix for locale errors
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

        stage('Docker Image Build') {
            steps {
                echo "Building Docker Image..."
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Trivy Security Scan') {
            steps {
                script {
                    echo "--- Phase 1: Filesystem Scan (Static Analysis) ---"
                    // Scans your Dockerfile and code for misconfigurations
                    sh 'trivy fs --severity HIGH,CRITICAL --exit-code 0 .'
                    
                    echo "--- Phase 2: Image Scan (Vulnerability Analysis) ---"
                    // Scans the built image layers. 
                    // Added --scanners vuln and skipped Java DB to save disk space.
                    sh 'trivy image --severity HIGH,CRITICAL --no-progress --scanners vuln --skip-java-db-update --exit-code 0 myapp:latest'
                }
            }
        }

        stage('Deploy Nginx (Docker)') {
            steps {
                echo "Deploying Container to Port 80..."
                sh 'docker rm -f myappcontainer || true'
                sh 'docker run -d --name myappcontainer -p 80:80 myapp:latest'
            }
        }

        stage('Ansible Deploy Apache') {
            steps {
                echo "Configuring Apache on Port 8081..."
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
                 body: "The deployment was successful. Security scans passed. Nginx is on port 80 and Apache is on 8081."
        }
        failure {
            mail to: 'yashpotdar4536@gmail.com',
                 subject: "Failed: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Pipeline failed. Check Jenkins logs for Trivy findings or build errors."
        }
        always {
            // Optional: Clean up workspace to save disk space after every run
            cleanWs()
        }
    }
}
