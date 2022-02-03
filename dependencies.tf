terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.27"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::558260051993:role/adfs-ftengdev-dev-softeng-app-dev"
    session_name = "EC2 Terraform session"
  }
}