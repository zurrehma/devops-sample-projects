variable "worker_max_size" {
  description = "Maximum number of EC2 instances for K8s Worker AutoScalingGroup"
  type        = number
  default     = 3
}

variable "worker_min_size" {
  description = "Minimum number of EC2 instances for K8s Worker AutoScalingGroup"
  type        = number
  default     = 3
}

variable "worker_size" {
  description = "Desired number of EC2 instances for K8s Worker AutoScalingGroup"
  type        = number
  default     = 3
}

variable "worker_instance_type" {
  description = "EC2 instance type for K8s worker instances"
  type        = string
  default     = "t3a.small"
}

variable "subnet" {
  type = string
}