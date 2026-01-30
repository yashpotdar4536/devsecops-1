pipeline {
    agent any
    
    environment {
        // This fixes the "unsupported locale setting" error for the jenkins user
        LC_ALL = 'en_IN.UTF-8'
        LANG   = 'en_IN.UTF-8'
    }

    stages {
        stage('GitHub Checkout') {
            steps {
                git url: 'https://github.com/yashpotdar4536/devsecops-1.git', branch: 'main'
            }
        }

        stage('Docker Image Build') {
            steps {
                sh 'docker build -t myapp:latest .'
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
    } // End of Stages

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
    } // End of Post
} // End of Pipeline
