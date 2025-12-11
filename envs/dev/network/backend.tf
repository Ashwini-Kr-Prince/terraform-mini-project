terraform {
  backend "s3" {
    bucket         = "my-tf-state-prod-mini"
    key            = "network/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

