pipeline {
    agent any

    environment {
        TF_DIR = "GitLab/terraform"
    }

    stages {
        stage('Init') {
            steps {
                sh '''
                    cd $TF_DIR
                    terraform init -input=false -upgrade
                '''
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    cd $TF_DIR
                    terraform validate
                '''
            }
        }

        stage('Plan') {
            steps {
                sh '''
                    cd $TF_DIR
                    terraform plan -out=tfplan
                '''
            }
        }

        stage('Apply') {
            steps {
                input message: 'Approve apply?', ok: 'Apply'
                sh '''
                    cd $TF_DIR
                    terraform apply -auto-approve tfplan
                '''
            }
        }
    }
}
