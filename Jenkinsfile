pipeline {
  agent none

  environment {
    TF_DIR = "GitLab/devops_first"   // 👈 updated path to your .tf files
    AWS_DEFAULT_REGION = "us-east-1"
  }

  parameters {
    string(name: 'KEY_NAME', defaultValue: 'my-keypair', description: 'Name of AWS key pair (TF var key_name)')
  }

  stages {
    stage('Init') {
      agent { docker { image 'hashicorp/terraform:1.6.6' } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                          usernameVariable: 'AWS_ACCESS_KEY_ID',
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh '''
            set -e
            cd "$TF_DIR"
            terraform init -input=false -upgrade
          '''
        }
        stash name: 'tf-artifacts', includes: "${TF_DIR}/**"
      }
    }

    stage('Validate') {
      agent { docker { image 'hashicorp/terraform:1.6.6' } }
      steps {
        unstash 'tf-artifacts'
        sh '''
          set -e
          cd "$TF_DIR"
          terraform validate
        '''
      }
    }

    stage('Plan') {
      agent { docker { image 'hashicorp/terraform:1.6.6' } }
      steps {
        unstash 'tf-artifacts'
        withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                          usernameVariable: 'AWS_ACCESS_KEY_ID',
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh '''
            set -e
            cd "$TF_DIR"
            echo "AWS Key prefix: $(echo $AWS_ACCESS_KEY_ID | cut -c1-4)****"
            echo "Secret length: ${#AWS_SECRET_ACCESS_KEY}"
            echo "Region: $AWS_DEFAULT_REGION"
            terraform plan -var="key_name=${KEY_NAME}" -out=tfplan
          '''
        }
        stash name: 'tf-plan', includes: "${TF_DIR}/**"
      }
    }

    stage('Apply (manual)') {
      agent { docker { image 'hashicorp/terraform:1.6.6' } }
      steps {
        unstash 'tf-plan'
        input message: "Approve terraform apply for branch ${env.BRANCH_NAME ?: env.GIT_BRANCH ?: 'unknown'}?",
              ok: 'Apply'
        withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                          usernameVariable: 'AWS_ACCESS_KEY_ID',
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh '''
            set -e
            cd "$TF_DIR"
            terraform apply -auto-approve tfplan
          '''
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline finished"
    }
  }
}
