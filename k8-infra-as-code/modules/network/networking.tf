data "aws_availability_zones" "available" {
  state = "available"
}
# vpc module which will be used to create k8 resources
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = var.vpc_name
  cidr   = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24"]

  enable_nat_gateway = true
  create_igw         = true

  private_subnet_names = [
    "K8-Controller-Manager-Subnet", "K8-Worker-Node-Subnet"
  ]

  tags = merge(
    var.tags
  )
  vpc_tags = merge({
    "Resource" = "k8-VPC"
    },
    var.tags
  )
  igw_tags = merge({
    "Resource" = "k8-VPC-IGW"
    },
    var.tags
  )
}



