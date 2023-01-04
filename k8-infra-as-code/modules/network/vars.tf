variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "tags" {
  type = object({
    Created_By = string
    Team       = string
  })
  default = {
    Created_By = "zurrehma"
    Team       = "DevOps"
  }
}