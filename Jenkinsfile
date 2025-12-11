pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
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
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'aws-terraform-creds',
                            usernameVariable: 'AWS_ACCESS_KEY_ID',
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        sh "terraform init -input=false"
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                dir('envs/dev/network') {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'aws-terraform-creds',
                            usernameVariable: 'AWS_ACCESS_KEY_ID',
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        sh """
                          terraform workspace select dev || terraform workspace new dev
                          terraform plan -var-file=dev.tfvars -out=tfplan
                        """
                    }
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
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'aws-terraform-creds',
                            usernameVariable: 'AWS_ACCESS_KEY_ID',
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        sh """
                          terraform workspace select dev || terraform workspace new dev
                          terraform apply -input=false tfplan
                        """
                    }
                }
            }
        }
    }
}

