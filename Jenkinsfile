pipeline {
    agent any

    environment {
        TF_DIR = "GitLab/terraform"
        TF_BIN = "${WORKSPACE}/terraform-bin/terraform"
    }

    stages {
        stage('Init') {
            steps {
                sh '''
                  cd $TF_DIR
                  $TF_BIN init -input=false -upgrade
                '''
            }
        }

        stage('Validate') {
            steps {
                sh '''
                  cd $TF_DIR
                  $TF_BIN validate
                '''
            }
        }

        stage('Plan') {
            steps {
                sh '''
                  cd $TF_DIR
                  $TF_BIN plan -var-file=terraform.tfvars -out=tfplan
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
                  $TF_BIN apply -auto-approve tfplan
                '''
            }
        }
    }
}
