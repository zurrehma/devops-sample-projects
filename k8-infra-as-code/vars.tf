variable "vpc_name" {
  type    = string
  default = "k8-infra-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "ami_owner" {
  type    = string
  default = "176232965299"
}

variable "k8_cp_subnet_name" {
  type    = string
  default = "K8-Controller-Manager-Subnet"
}

variable "etcd_instance_type" {
  description = "EC2 instance type for etcd instances"
  type        = string
  default     = "t3a.small"
}

variable "k8_cp_ami_name" {
  type    = string
  default = "k8-packer-ami"
}

variable "ansible_ami_name" {
  type    = string
  default = "ansible-packer-ami"
}

variable "ansible_instance_type" {
  description = "EC2 instance type for ansible instance"
  type        = string
  default     = "t3a.small"
}

variable "master_instance_type" {
  description = "EC2 instance type for K8s master instances"
  type        = string
  default     = "t3a.small"
}

variable "etcd_max_size" {
  description = "Maximum number of EC2 instances for etcd AutoScalingGroup"
  type        = number
  default     = 3
}

variable "etcd_min_size" {
  description = "Minimum number of EC2 instances for etcd AutoScalingGroup"
  type        = number
  default     = 3
}

variable "etcd_size" {
  description = "Desired number of EC2 instances for etcd AutoScalingGroup"
  type        = number
  default     = 3
}

variable "master_max_size" {
  description = "Maximum number of EC2 instances for K8s Master AutoScalingGroup"
  type        = number
  default     = 3
}

variable "master_min_size" {
  description = "Minimum number of EC2 instances for K8s Master AutoScalingGroup"
  type        = number
  default     = 3
}

variable "master_size" {
  description = "Desired number of EC2 instances for K8s Master AutoScalingGroup"
  type        = number
  default     = 3
}

variable "create_ansible_cp" {
  type    = bool
  default = true
}

variable "ansible_max_size" {
  description = "Maximum number of EC2 instances for ansible AutoScalingGroup"
  type        = number
  default     = 1
}

variable "ansible_min_size" {
  description = "Minimum number of EC2 instances for ansible AutoScalingGroup"
  type        = number
  default     = 1
}

variable "ansible_size" {
  description = "Desired number of EC2 instances for ansible AutoScalingGroup"
  type        = number
  default     = 1
}