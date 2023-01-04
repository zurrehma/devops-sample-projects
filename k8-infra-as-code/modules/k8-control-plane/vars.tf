variable "ami_owner" {
  type = string
}

variable "k8_cp_ami_name" {
  type = string
}

variable "k8_cp_subnet_name" {
  type    = string
  default = "K8-Controller-Manager-Subnet"
}

variable "master_instance_type" {
  description = "EC2 instance type for K8s master instances"
  type        = string
  default     = "t3a.small"
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

variable "etcd_instance_type" {
  description = "EC2 instance type for etcd instances"
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

variable "k8_nodes_security_group_id" {
  type = string
}


variable "tags" {
  type = object({
    Created_By = string
    Team       = string
  })
  default = {
    Created_By = "zurrehma"
    Team       = "DevOps/Logging-Kibana"
  }
}

# variable "k8-node-sg-id" {
#   type = string
# }

variable "k8-node-instance-profile-arn" {
  type = string
}

variable "cp-subnet" {
  type = string
}

