variable "vpc_name" {
  type = string
  default = "k8-infra-vpc"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "aws_region" {
  type = string
  default = "eu-west-1"
}