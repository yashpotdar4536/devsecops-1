pipeline {
    agent any

    stages {
        stage('GitHub Checkout') {
            steps {
                git url: 'https://github.com/yashpotdar4536/devsecops-1.git', branch: 'main'
            }
        }

        stage('Docker Image Build') {
            steps {
                // Builds the Nginx image using your Dockerfile
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Deploy Nginx (Docker)') {
            steps {
                // Cleans up old container and runs new one on Port 80
                sh 'docker rm -f myappcontainer || true'
                sh 'docker run -d --name myappcontainer -p 80:80 myapp:latest'
            }
        }

        stage('Ansible Deploy Apache') {
            steps {
                // Triggers the playbook to install Apache on Port 8081
                // Ensure 'Ansible' is the name configured in Global Tool Configuration
                ansiblePlaybook(
                    playbook: 'apache.yml',
                    inventory: 'inventory.ini',
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
                 body: "The deployment was successful. Nginx is on port 80 and Apache is on 8081."
        }
        failure {
            mail to: 'yashpotdar4536@gmail.com',
                 subject: "Failed: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Pipeline failed. Check the Jenkins console logs for errors."
        }
    }
}
    }
}

