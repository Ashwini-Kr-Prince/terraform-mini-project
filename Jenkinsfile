pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-terraform-creds').username
        AWS_SECRET_ACCESS_KEY = credentials('aws-terraform-creds').password
        AWS_DEFAULT_REGION    = "ap-south-1"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Init') {
            steps {
                dir('envs/dev/network') {
                    sh "terraform init -input=false"
                }
            }
        }

        stage('Plan') {
            steps {
                dir('envs/dev/network') {
                    sh "terraform workspace select dev || terraform workspace new dev"
                    sh "terraform plan -var-file=dev.tfvars -out=tfplan"
                }
            }
        }

        stage('Apply Approval') {
            steps {
                script {
                    input message: "Apply Terraform changes for DEV NETWORK?", ok: "Apply"
                }
            }
        }

        stage('Apply') {
            steps {
                dir('envs/dev/network') {
                    sh "terraform apply -input=false tfplan"
                }
            }
        }
    }
}

