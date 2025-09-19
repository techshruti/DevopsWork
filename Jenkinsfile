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
                  terraform plan -var-file=terraform.tfvars -out=tfplan
                '''
            }
        }

        stage('Apply') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                  cd $TF_DIR
                  terraform apply -auto-approve tfplan
                '''
            }
        }
    }
}
