variable "vpc_id" {
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

variable "create_ansible_cp" {
  type = bool
}