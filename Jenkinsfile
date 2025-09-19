pipeline {
    agent any

    environment {
        TF_DIR = "GitLab/terraform"
        TF_BIN = "${WORKSPACE}/terraform-bin"
        PATH = "${TF_BIN}:${env.PATH}"
    }

    stages {
        stage('Setup Terraform') {
            steps {
                sh 'ls -l $TF_BIN'   // just to confirm terraform binary exists
                sh 'terraform version'
            }
        }

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
            when { branch "main" }
            steps {
                sh '''
                  cd $TF_DIR
                  terraform apply -auto-approve tfplan
                '''
            }
        }
    }
}
