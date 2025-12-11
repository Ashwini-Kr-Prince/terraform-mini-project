terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  env = terraform.workspace

  common_tags = {
    env     = local.env
    project = "tf-prod-mini"
    owner   = "devops-lab"
  }
}

module "network" {
  source          = "../../../modules/network"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  tags            = local.common_tags
}

output "vpc_id" {
  value = module.network.vpc_id
}

