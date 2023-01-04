variable "ami_owner" {
  type = string
}

variable "ansible_security_group_id" {
  type = string
}

variable "ansible-node-instance-profile-arn" {
  type = string
}

variable "ansible_ami_name" {
  type = string
}

variable "create_ansible_cp" {
  type = bool
}

variable "ansible_instance_type" {
  description = "EC2 instance type for ansible instance"
  type        = string
  default     = "t3a.small"
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

variable "ansible_subnet" {
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