pipeline {
    agent any

    environment {
        TF_DIR = "GitLab/terraform"
        TF_VERSION = "1.6.6"
    }

    stages {
        stage('Setup Terraform') {
            steps {
                sh '''
                  echo "Downloading Terraform v$TF_VERSION..."
                  curl -fsSL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -o terraform.zip
                  rm -rf terraform-bin
                  mkdir terraform-bin
                  unzip -q terraform.zip -d terraform-bin
                  rm terraform.zip
                  chmod +x terraform-bin/terraform
                  export PATH=$PWD/terraform-bin:$PATH
                  terraform -version
                '''
            }
        }

        stage('Init') {
            steps {
                sh '''
                  export PATH=$PWD/terraform-bin:$PATH
                  cd $TF_DIR
                  terraform init -input=false -upgrade
                '''
            }
        }

        stage('Validate') {
            steps {
                sh '''
                  export PATH=$PWD/terraform-bin:$PATH
                  cd $TF_DIR
                  terraform validate
                '''
            }
        }

        stage('Plan') {
            steps {
                sh '''
                  export PATH=$PWD/terraform-bin:$PATH
                  cd $TF_DIR
                  echo "AWS Access Key starts with: ${AWS_ACCESS_KEY_ID:0:4}"
                  echo "Secret length: ${#AWS_SECRET_ACCESS_KEY}"
                  echo "Region: $AWS_DEFAULT_REGION"
                  terraform plan -var="key_name=$KEY_NAME" -out=tfplan
                '''
            }
        }

        stage('Apply (manual)') {
            steps {
                input "Proceed with Terraform Apply?"
                sh '''
                  export PATH=$PWD/terraform-bin:$PATH
                  cd $TF_DIR
                  terraform apply -auto-approve tfplan
                '''
            }
        }
    }
}
