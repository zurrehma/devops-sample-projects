output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_public_subnet" {
  value = module.vpc.public_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}