terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  #remote backend
  backend "s3" {
    bucket  = "gha-java-app-20260611"
    key     = "vpc/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}
provider "aws" {
  region = var.aws_region
}