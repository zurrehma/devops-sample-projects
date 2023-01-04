module "vpc" {
  source     = "./modules/network"
  vpc_cidr   = var.vpc_cidr
  aws_region = var.aws_region
  vpc_name   = var.vpc_name
  tags       = local.tags
}

module "common-resources" {
  source            = "./modules/common-resources"
  vpc_id            = module.vpc.vpc_id
  create_ansible_cp = var.create_ansible_cp
}

module "k8-controlplane" {
  source                       = "./modules/k8-control-plane"
  ami_owner                    = var.ami_owner
  k8_cp_ami_name               = var.k8_cp_ami_name
  k8_cp_subnet_name            = var.k8_cp_subnet_name
  master_instance_type         = var.master_instance_type
  master_max_size              = var.master_max_size
  master_min_size              = var.master_min_size
  etcd_instance_type           = var.etcd_instance_type
  etcd_max_size                = var.etcd_max_size
  etcd_min_size                = var.etcd_min_size
  k8_nodes_security_group_id   = module.common-resources.k8-node-sg-id
  k8-node-instance-profile-arn = module.common-resources.k8-node-instance-profile-arn
  cp-subnet                    = module.vpc.vpc_private_subnets[0]
}

module "ansible" {
  source                            = "./modules/ansible-module"
  create_ansible_cp                 = var.create_ansible_cp
  ansible-node-instance-profile-arn = module.common-resources.ansible-node-instance-profile-arn
  ansible_security_group_id         = module.common-resources.ansible-node-sg-id
  ansible_ami_name                  = var.ansible_ami_name
  ansible_subnet                    = module.vpc.vpc_public_subnet[0]
  ami_owner                         = var.ami_owner
}

