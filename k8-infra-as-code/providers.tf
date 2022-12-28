terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  
}