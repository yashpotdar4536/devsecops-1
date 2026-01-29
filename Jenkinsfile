pipeline {
    agent any

    stages {
        stage('GitHub config') {
            steps {
                git url:'https://github.com/yashpotdar4536/devsecops-1.git', branch:'main'
            }
        }

       stage('Ansible Infra Setup') {
    steps {
        // This 'installation' name must match the name you set in Global Tool Configuration
        ansiblePlaybook(
            playbook: 'apache.yml',
            inventory: 'inventory.ini',
            credentialsId: 'ec2-ssh-key',
            colorized: true,
            disableHostKeyChecking: true,
            installation: 'Ansible' 
        )
    }
}

        stage('Docker image build') {
            steps {
                sh 'docker build -t myapp .'
            }
        }

        stage('Docker container build') {
            steps {
                // We use port 9000 to avoid conflict with Jenkins(8080) and Apache(80)
                sh 'docker rm -f myappcontainer || true'
                sh 'docker run -d --name myappcontainer -p 9000:80 myapp' 
            }
        }
    }

    post {
        success {
            mail to: 'yashpotdar4536@gmail.com',
                 subject: "Success: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Deployment successful! View site at http://192.168.56.147"
        }
        failure {
            mail to: 'yashpotdar4536@gmail.com',
                 subject: "Failed: Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Build failed. Check logs at ${env.BUILD_URL}"
        }
    }
}
